# === Config: Delete Zone-Level IP Access Rules ===
$headers = @{
  "X-Auth-Email" = "your-email@example.com"
  "X-Auth-Key"   = "your-global-api-key"
  "Content-Type" = "application/json"
}

$zoneId = "your-zone-id"  # Replace with the actual zone ID (important)

# === Optional output logs ===
$successLog = "$env:USERPROFILE\Desktop\deleted_zone_rules.txt"
$failLog    = "$env:USERPROFILE\Desktop\failed_deletions.txt"

$allRules = @()
$page = 1
$perPage = 100
$totalPages = 1
$retryCount = 0

Write-Host "`nFetching IP access rules for zone: $zoneId..." -ForegroundColor Cyan

do {
    $url = "https://api.cloudflare.com/client/v4/zones/$zoneId/firewall/access_rules/rules?page=$page&per_page=$perPage"

    try {
        $response = Invoke-RestMethod -Uri $url -Headers $headers -Method GET

        if ($response.success -eq $true) {
            $allRules += $response.result
            $totalPages = $response.result_info.total_pages
            $page++
            $retryCount = 0
        } else {
            Write-Host "API error retrieving rules on page $page." -ForegroundColor Red
            $page++
        }
    } catch {
        Write-Host ("Error on page $page`: " + $_.Exception.Message) -ForegroundColor Red
        $page++
    }
} while ($page -le $totalPages -and $retryCount -lt 10)

Write-Host "`nFound $($allRules.Count) zone-level rule(s) to delete." -ForegroundColor Yellow

# === Delete rules one by one ===
$counter = 0
$successList = @()
$failList = @()

foreach ($rule in $allRules) {
    $counter++
    $ruleId = $rule.id
    $ip = $rule.configuration.value
    $url = "https://api.cloudflare.com/client/v4/zones/$zoneId/firewall/access_rules/rules/$ruleId"

    Write-Progress -Activity "Deleting zone-level rules" `
                   -Status "Deleting rule $counter of $($allRules.Count)" `
                   -PercentComplete (($counter / $allRules.Count) * 100)

    try {
        $delResponse = Invoke-RestMethod -Uri $url -Headers $headers -Method DELETE

        if ($delResponse.success -eq $true) {
            Write-Host "Deleted: $ip (ID: $ruleId)" -ForegroundColor Green
            $successList += "Deleted: $ip (ID: $ruleId)"
        } else {
            Write-Host "Failed to delete: $ip (ID: $ruleId)" -ForegroundColor Red
            $failList += "Failed: $ip (ID: $ruleId) - API failure"
        }
    } catch {
        Write-Host ("Error deleting $ip`: " + $_.Exception.Message) -ForegroundColor Red
        $failList += "Error: $ip - $($_.Exception.Message)"
    }
}

# === Save logs ===
$successList | Out-File -Encoding utf8 $successLog
$failList | Out-File -Encoding utf8 $failLog

Write-Host "`nCompleted." -ForegroundColor Cyan
Write-Host "Successes saved to: $successLog"
Write-Host "Failures saved to:  $failLog"
