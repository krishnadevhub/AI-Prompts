## Ask Devin to Triage a Ticket 
Log into ADO Azure CLI using the service principal credentials stored in environment variables. Read recent comments on the ADO ticket where Devin is tagged, review in terms of this query, and comment back on the ticket with your response. If it asks you to triage a ticket you will be given an ADO number you are to retrieve the ADO using the Azure CLI and review it to ensure enough details are given for someone to resolve the query.

What’s Needed From User : An ADO number or an ADO link.

### Procedure:
1. Log into Azure CLI using the service principal credentials stored in environment variables.
2. Read the ticket, and any logs or images attached to the ticket for further details. Verify the ticket includes details in the Repro Steps section to describe the issue, steps to reproduce, and details of the customer environment. If not, comment on the ticket that details are missing, tagging the reporter.
3. Use [repository-ame] code repos to analyse the query.
4. Investigate the root cause of a bug and identify the responsible code section. Draft or scaffold a solution (code, config, documentation outline). Identify dependencies or blockers that need resolution before the item can be completed. Estimate remaining effort based on findings. Commit any concrete code progress to a working branch named devin/backlog-[item-id]. Do not merge or raise a pull request without explicit instruction.

Output: Any conclusions or explanations to the cause of the issue please add them as a comment to the Bug ADO. Clearly indicate for each of these sources if information has or has not been used: code, historical tickets, wiki repo, external sources. Include links and references to the source material you used in the response, use the full URL to help navigation. Preface all comments with a banner to highlight it is AI Generated Content for Internal Use Only. Format the ADO comment using full HTML with extra header spacing. Update the Devin Session ID field on the ticket with the devin session number.

### Deliverables.
Either
A Comment on the ADO Bug describing the possible cause of the issue.
or
A comment on the ADO requesting further details if the ticket provided insufficient information.
Now, following these rules, please process ADO number 1651546.
