# Google Sheets Tracker Setup (5 minutes)

## Step 1: Create the Google Sheet

1. Go to https://sheets.google.com → Create new spreadsheet
2. Name it: **Job Applications Tracker**
3. In Row 1, add these headers:

| A | B | C | D | E | F | G | H | I |
|---|---|---|---|---|---|---|---|---|
| Date | Company | Title | Location | Fit Score | ATS Gemini | ATS DeepSeek | Verdict | Status |

## Step 2: Create the Apps Script Web App

1. In the spreadsheet, go to **Extensions → Apps Script**
2. Delete everything in Code.gs and paste this:

```javascript
function doPost(e) {
  var sheet = SpreadsheetApp.getActiveSpreadsheet().getActiveSheet();
  var data = JSON.parse(e.postData.contents);

  sheet.appendRow([
    data.date || new Date().toISOString(),
    data.company || '',
    data.title || '',
    data.location || '',
    data.fit_score || '',
    data.ats_gemini || '',
    data.ats_deepseek || '',
    data.verdict || '',
    data.status || 'tailored'
  ]);

  return ContentService
    .createTextOutput(JSON.stringify({ result: 'ok', row: sheet.getLastRow() }))
    .setMimeType(ContentService.MimeType.JSON);
}
```

3. Click **Deploy → New deployment**
4. Type: **Web app**
5. Execute as: **Me**
6. Who has access: **Anyone**
7. Click **Deploy** and copy the URL (looks like `https://script.google.com/macros/s/XXXXX/exec`)

## Step 3: Update n8n

Replace the "Log to Google Sheets" node URL in n8n with your Apps Script URL.
The node ID is `sheets-log`.

That's it. Every job you tailor will auto-log to the spreadsheet.
