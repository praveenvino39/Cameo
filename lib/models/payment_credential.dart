class PaymentCredential {
  PaymentCredential(
      {this.paypalClientId,
      this.paypalSecretId,
      this.stripePublishableKey,
      this.stripeSecretKey});

  String paypalClientId;
  String paypalSecretId;
  String stripePublishableKey;
  String stripeSecretKey;
}
