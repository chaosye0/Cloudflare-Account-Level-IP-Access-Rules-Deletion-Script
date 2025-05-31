Cloudflare account-Level IP Access Rules deletion script
a script to auto delete hundreds of account-Level IP Access Rules.

Thanks for alexfot94's "Cloudflare-Zone-Level-IP-Access-Rules-Deletion-Script". This script is modified from his work.


Before running the script, update the following configuration block with your actual Cloudflare credentials:

{
  "X-Auth-Email" = "your-email@example.com"
  "X-Auth-Key"   = "your-global-api-key"
  "Content-Type" = "application/json"
}

Usage

    Open PowerShell.

    Update the script with your credentials and account ID.

    Run the script.

    The script will:

        Fetch all current account-level IP Access Rules.

        Delete each rule individually.

        Track and log successful and failed deletions.

Output

The following log files will be saved to your Desktop:

    deleted_account_rules.txt
    Contains a list of all successfully deleted rules.

    failed_deletions.txt
    Contains details of any rules that could not be deleted, including API errors or exceptions.

Safety & Notes

    This script performs irreversible deletions of IP Access Rules. Use with caution.

    Always review the list of rules retrieved before deletion in a test environment if possible.

    Make a backup of current rules using an export script beforehand.

License

This script is provided under the MIT License. You are free to use, modify, and distribute it.
