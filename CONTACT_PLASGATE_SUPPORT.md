# Contact PlasGate Support About HTTP 203 Error

## Issue Summary

We're consistently getting **HTTP 203 "Non-Authoritative Information"** when calling the PlasGate REST API, even though:
- ✅ API credentials are correct
- ✅ Request format matches documentation
- ✅ Sender name "PlasGateUAT" is approved
- ✅ Endpoint is correct: `https://cloudapi.plasgate.com/rest/send`

## Request Details

**Endpoint:** `https://cloudapi.plasgate.com/rest/send`

**Method:** POST

**Headers:**
- `X-Secret`: [Your secret key]
- `Content-Type`: application/json

**Query Parameter:**
- `private_key`: [Your private key]

**Request Body:**
```json
{
  "sender": "PlasGateUAT",
  "to": "85512222211",
  "content": "Master Elf: Your consultation (Service Name) is confirmed on 2026-02-09 at 14:00. Ref: ABC123."
}
```

## Response Received

**Status Code:** 203 Non-Authoritative Information

**Response Body:**
```json
{
  "message": "203 Non-Authoritative Information"
}
```

## Questions for PlasGate Support

1. **What does HTTP 203 mean for your API?** 
   - Is this an error or a success response?
   - Why are we getting 203 instead of 200 OK?

2. **UAT Account Restrictions:**
   - Is "PlasGateUAT" a test/UAT account that doesn't actually send SMS?
   - Do UAT accounts require different endpoints or parameters?
   - Do we need to upgrade to a production account?

3. **Account Status:**
   - Is our account active and properly configured?
   - Are there any restrictions on our account?
   - Is there sufficient balance?

4. **Sender Name:**
   - Is "PlasGateUAT" correctly configured?
   - Should we use a different sender name?
   - Are there any sender name restrictions?

5. **API Endpoint:**
   - Is `https://cloudapi.plasgate.com/rest/send` the correct endpoint?
   - Are there different endpoints for UAT vs production?

## Email Template

**To:** admin@plasgate.com

**Subject:** HTTP 203 Error When Sending SMS via REST API

**Body:**

Hello PlasGate Support,

We are experiencing an issue when sending SMS messages via your REST API. We consistently receive HTTP 203 "Non-Authoritative Information" responses instead of the expected 200 OK.

**Account Details:**
- Account Email: [Your email]
- Sender Name: PlasGateUAT
- API Endpoint: https://cloudapi.plasgate.com/rest/send

**Request Format:**
- Method: POST
- Headers: X-Secret, Content-Type: application/json
- Query Parameter: private_key
- Body: JSON with sender, to, content

**Response:**
- Status: 203 Non-Authoritative Information
- Body: {"message": "203 Non-Authoritative Information"}

**Questions:**
1. What does HTTP 203 indicate for your API?
2. Is this related to using a UAT account?
3. Do we need to configure something differently?
4. Should we use a different endpoint or sender name?

We have verified:
- API credentials are correct
- Request format matches your documentation
- Sender name is approved
- Account has balance

Could you please help us resolve this issue?

Thank you,
[Your name]

## Alternative: Check Dashboard First

Before emailing, check your PlasGate dashboard:
1. **Account Status** - Is it active?
2. **Balance** - Do you have credits?
3. **API Settings** - Any restrictions?
4. **Sender Names** - List of approved senders
5. **API Logs** - See if requests are being received
6. **Documentation** - Check for UAT-specific instructions

## Next Steps

1. **Check PlasGate Dashboard** for account status and settings
2. **Email admin@plasgate.com** with the details above
3. **Wait for response** and follow their guidance
4. **Update function** based on their recommendations
