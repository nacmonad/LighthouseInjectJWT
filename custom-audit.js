const { audit } = require('lighthouse');

class CustomAudit {
  static get meta() {
    return {
      id: 'custom-audit',
      title: 'Custom Audit',
      scoreDisplayMode: 'binary'
    };
  }

  static async audit(context, options) {
    // Inject JWT into local storage
    const page = context.page;
    await page.evaluate((jwt) => {
      localStorage.setItem('jwt', jwt);
    }, options.jwt);

    // Run Lighthouse audit
    const result = await audit(context, { ...options, url: options.url });

    // Clean up after the audit
    await page.evaluate(() => {
      localStorage.removeItem('jwt');
    });

    // Return the audit result
    return result;
  }
}

module.exports = CustomAudit;
