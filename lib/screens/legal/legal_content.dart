import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

/// Generic standard legal text for Terms, Disclaimer, and Privacy.
/// Replace with your own content when you have final copy.
enum LegalPage { terms, disclaimer, privacy }

class LegalContent {
  LegalContent._();

  static String title(BuildContext context, LegalPage page) {
    final l10n = AppLocalizations.of(context)!;
    switch (page) {
      case LegalPage.terms:
        return l10n.termsOfService;
      case LegalPage.disclaimer:
        return l10n.disclaimer;
      case LegalPage.privacy:
        return l10n.privacyPolicy;
    }
  }

  static String body(BuildContext context, LegalPage page) {
    switch (page) {
      case LegalPage.terms:
        return _termsBody;
      case LegalPage.disclaimer:
        return _disclaimerBody;
      case LegalPage.privacy:
        return _privacyBody;
    }
  }

  static const String _termsBody = '''
Last updated: 2026

1. Acceptance of Terms
By accessing and using this website and related services ("Services") operated by Master Elf Feng Shui Co., Ltd. ("Company", "we", "us"), you accept and agree to be bound by these Terms of Service. If you do not agree, please do not use our Services.

2. Description of Services
We provide information, consultations, events, and educational content related to Feng Shui, BaZi, Qi Men, and related practices. Services are offered at our discretion and may be modified or discontinued without notice.

3. User Conduct
You agree to use the Services only for lawful purposes. You may not use the Services to harass, defame, or harm others, or to distribute malicious or illegal content. We reserve the right to suspend or terminate access for any user who violates these terms.

4. Intellectual Property
All content on this website (text, images, logos, and materials) is owned by the Company or its licensors and is protected by copyright and other intellectual property laws. You may not copy, modify, or distribute our content without prior written permission.

5. Consultations and Events
Bookings for consultations and events are subject to availability and our cancellation policy. Fees and payment terms will be communicated at the time of booking. We do not guarantee specific outcomes from any consultation or event.

6. Disclaimer of Warranties
The Services are provided "as is" without warranties of any kind. We do not warrant that the Services will be uninterrupted or error-free. Your use of the Services is at your own risk.

7. Limitation of Liability
To the fullest extent permitted by law, the Company shall not be liable for any indirect, incidental, special, or consequential damages arising from your use of the Services.

8. Changes to Terms
We may update these Terms from time to time. Continued use of the Services after changes constitutes acceptance of the revised Terms.

9. Contact
For questions about these Terms, please contact us via the contact information provided on this website.
''';

  static const String _disclaimerBody = '''
Last updated: 2026

General Disclaimer
The information and content provided on this website and through our consultations, events, and materials (collectively, "Content") are for general informational and educational purposes only. They are not intended as professional advice and should not replace advice from qualified professionals in legal, financial, medical, or other fields.

No Guarantee of Outcomes
Feng Shui, BaZi, Qi Men, date selection, and related practices are traditional systems. We do not guarantee any specific result, outcome, or benefit from following our recommendations or attending our events. Outcomes depend on many factors beyond our control.

Personal Responsibility
You are solely responsible for your decisions and actions. Any choices you make based on our Content or consultations are made at your own risk. We encourage you to use your own judgment and, where appropriate, to seek independent professional advice.

Accuracy of Information
While we strive to provide accurate and up-to-date information, we do not warrant the completeness, reliability, or accuracy of the Content. Information may change over time, and we are not obligated to update every item on the website.

Third-Party Links
This website may contain links to third-party sites. We are not responsible for the content or practices of those sites. Links do not imply endorsement.

Consultation and Event Disclaimer
Consultations and events are offered for educational and informational purposes. They are not a substitute for professional advice in any field. Results may vary.

Contact
If you have questions about this Disclaimer, please contact us using the information on this website.
''';

  static const String _privacyBody = '''
Last updated: 2026

1. Introduction
Master Elf Feng Shui Co., Ltd. ("we", "us", "our") respects your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our website and services.

2. Information We Collect
We may collect information you provide directly, such as:
• Name and contact details (e.g., email, phone) when you book a consultation, register for an event, or contact us
• Payment information when you make a purchase (processed by third-party payment providers)
• Messages and correspondence you send to us

We may also automatically collect certain information when you visit our website, such as:
• Device and browser type, IP address
• Pages visited and time spent on the site
• Referring website or source

3. How We Use Your Information
We use the information we collect to:
• Provide, maintain, and improve our services
• Process bookings and transactions
• Send you relevant updates, event reminders, or marketing communications (where you have agreed)
• Respond to your inquiries and support requests
• Comply with legal obligations and protect our rights

4. Sharing of Information
We do not sell your personal information. We may share your information with:
• Service providers who assist us (e.g., hosting, email, payment processors), subject to confidentiality obligations
• Authorities when required by law or to protect our rights and safety

5. Cookies and Similar Technologies
We may use cookies and similar technologies to improve your experience, analyze usage, and remember your preferences. You can adjust your browser settings to limit or block cookies.

6. Data Security
We implement reasonable measures to protect your personal information. However, no method of transmission or storage is 100% secure, and we cannot guarantee absolute security.

7. Data Retention
We retain your information for as long as necessary to fulfill the purposes described in this policy or as required by law.

8. Your Rights
Depending on applicable law, you may have the right to access, correct, or delete your personal information, or to object to or restrict certain processing. To exercise these rights, please contact us.

9. Children
Our services are not directed to individuals under the age of 18. We do not knowingly collect personal information from children.

10. Changes to This Policy
We may update this Privacy Policy from time to time. We will post the revised policy on this page and update the "Last updated" date.

11. Contact Us
For questions or requests regarding this Privacy Policy or your personal data, please contact us using the contact information on this website.
''';
}
