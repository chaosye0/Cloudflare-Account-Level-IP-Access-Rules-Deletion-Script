Cloudflare Zone-Level IP Access Rules Deletion Script
Overview

This PowerShell script automates the deletion of all zone-level IP Access Rules (firewall rules) from a specified Cloudflare zone. It fetches all rules associated with a zone and removes them one by one using the Cloudflare API.

This is especially useful for:

    Cleaning up deprecated or temporary firewall rules.

    Resetting a zone’s access control configuration.

    Automating security policy enforcement.

Technologies Used

    PowerShell: Script automation and system integration.

    Cloudflare API v4: Used to manage firewall rules at the zone level.

    JSON over HTTPS: Communication with the API using standard REST principles.

Prerequisites

    PowerShell 5.1+ (Windows) or PowerShell Core (macOS/Linux).

    A valid Cloudflare account with:

        A registered email address.

        A Global API Key (not API token).

        The Zone ID of the site you want to manage (found in the Cloudflare dashboard).

Script Configuration

Before running the script, update the following configuration block with your actual Cloudflare credentials:

$headers = @{
  "X-Auth-Email" = "your-email@example.com"
  "X-Auth-Key"   = "your-global-api-key"
  "Content-Type" = "application/json"
}

$zoneId = "your-zone-id"  # Replace with your Cloudflare zone ID

Usage

    Open PowerShell.

    Update the script with your credentials and zone ID.

    Run the script.

    The script will:

        Fetch all current zone-level IP Access Rules.

        Delete each rule individually.

        Track and log successful and failed deletions.

Output

The following log files will be saved to your Desktop:

    deleted_zone_rules.txt
    Contains a list of all successfully deleted rules.

    failed_deletions.txt
    Contains details of any rules that could not be deleted, including API errors or exceptions.

Safety & Notes

    This script performs irreversible deletions of IP Access Rules. Use with caution.

    Always review the list of rules retrieved before deletion in a test environment if possible.

    Make a backup of current rules using an export script beforehand.

License

This script is provided under the MIT License. You are free to use, modify, and distribute it.
