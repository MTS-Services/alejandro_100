class PaymentSettingModel {
  String? success;
  String? error;
  String? message;
  Strip? strip;
  Cash? cash;
  PayFast? payFast;
  Cash? myWallet;
  PayStack? payStack;
  FlutterWave? flutterWave;
  RazorpayModel? razorpay;
  Mercadopago? mercadopago;
  PayPal? payPal;
  Xendit? xendit;
  OrangePay? orangePay;
  Midtrans? midtrans;

  PaymentSettingModel({
    this.success,
    this.error,
    this.message,
    this.strip,
    this.cash,
    this.payFast,
    this.myWallet,
    this.payStack,
    this.flutterWave,
    this.razorpay,
    this.mercadopago,
    this.payPal,
    this.midtrans,
    this.orangePay,
    this.xendit,
  });

  PaymentSettingModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    message = json['message'];
    strip = json['Strip'] != null ? Strip.fromJson(json['Strip']) : null;
    cash = json['Cash'] != null ? Cash.fromJson(json['Cash']) : null;
    payFast = json['PayFast'] != null ? PayFast.fromJson(json['PayFast']) : null;
    myWallet = json['My Wallet'] != null ? Cash.fromJson(json['My Wallet']) : null;
    payStack = json['PayStack'] != null ? PayStack.fromJson(json['PayStack']) : null;
    flutterWave = json['FlutterWave'] != null ? FlutterWave.fromJson(json['FlutterWave']) : null;
    razorpay = json['Razorpay'] != null ? RazorpayModel.fromJson(json['Razorpay']) : null;
    mercadopago = json['Mercadopago'] != null ? Mercadopago.fromJson(json['Mercadopago']) : null;
    payPal = json['PayPal'] != null ? PayPal.fromJson(json['PayPal']) : null;
    xendit = json['Xendit'] != null ? Xendit.fromJson(json['Xendit']) : null;
    orangePay = json['OrangePay'] != null ? OrangePay.fromJson(json['OrangePay']) : null;
    midtrans = json['Midtrans'] != null ? Midtrans.fromJson(json['Midtrans']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['error'] = error;
    data['message'] = message;
    if (strip != null) {
      data['Strip'] = strip!.toJson();
    }
    if (cash != null) {
      data['Cash'] = cash!.toJson();
    }
    if (payFast != null) {
      data['PayFast'] = payFast!.toJson();
    }
    if (myWallet != null) {
      data['My Wallet'] = myWallet!.toJson();
    }
    if (payStack != null) {
      data['PayStack'] = payStack!.toJson();
    }
    if (flutterWave != null) {
      data['FlutterWave'] = flutterWave!.toJson();
    }
    if (razorpay != null) {
      data['Razorpay'] = razorpay!.toJson();
    }
    if (mercadopago != null) {
      data['Mercadopago'] = mercadopago!.toJson();
    }
    if (payPal != null) {
      data['PayPal'] = payPal!.toJson();
    }
    if (midtrans != null) {
      data['Midtrans'] = midtrans!.toJson();
    }
    if (orangePay != null) {
      data['OrangePay'] = orangePay!.toJson();
    }
    if (xendit != null) {
      data['Xendit'] = xendit!.toJson();
    }
    return data;
  }
}

class Strip {
  String? id;
  String? key;
  String? clientpublishableKey;
  String? secretKey;
  String? isEnabled;
  String? isSandboxEnabled;
  String? idPaymentMethod;
  String? libelle;

  Strip({this.id, this.key, this.clientpublishableKey, this.secretKey, this.isEnabled, this.isSandboxEnabled, this.idPaymentMethod, this.libelle});

  Strip.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    key = json['key'].toString();
    clientpublishableKey = json['clientpublishableKey'].toString();
    secretKey = json['secret_key'].toString();
    isEnabled = json['isEnabled'].toString();
    isSandboxEnabled = json['isSandboxEnabled'].toString();
    idPaymentMethod = json['id_payment_method'].toString();
    libelle = json['libelle'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['key'] = key;
    data['clientpublishableKey'] = clientpublishableKey;
    data['secret_key'] = secretKey;
    data['isEnabled'] = isEnabled;
    data['isSandboxEnabled'] = isSandboxEnabled;
    data['id_payment_method'] = idPaymentMethod;
    data['libelle'] = libelle;
    return data;
  }
}

class Cash {
  String? id;
  String? isEnabled;
  String? libelle;
  String? idPaymentMethod;

  Cash({this.id, this.isEnabled, this.libelle, this.idPaymentMethod});

  Cash.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    isEnabled = json['isEnabled'].toString();
    libelle = json['libelle'].toString();
    idPaymentMethod = json['id_payment_method'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['isEnabled'] = isEnabled;
    data['libelle'] = libelle;
    data['id_payment_method'] = idPaymentMethod;
    return data;
  }
}

class PayFast {
  String? id;
  String? merchantId;
  String? merchantKey;
  String? cancelUrl;
  String? notifyUrl;
  String? returnUrl;
  String? isEnabled;
  String? isSandboxEnabled;
  String? idPaymentMethod;
  String? libelle;

  PayFast({this.id, this.merchantId, this.merchantKey, this.cancelUrl, this.notifyUrl, this.returnUrl, this.isEnabled, this.isSandboxEnabled, this.idPaymentMethod, this.libelle});

  PayFast.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    merchantId = json['merchant_Id'].toString();
    merchantKey = json['merchant_key'].toString();
    cancelUrl = json['cancel_url'].toString();
    notifyUrl = json['notify_url'].toString();
    returnUrl = json['return_url'].toString();
    isEnabled = json['isEnabled'].toString();
    isSandboxEnabled = json['isSandboxEnabled'].toString();
    idPaymentMethod = json['id_payment_method'].toString();
    libelle = json['libelle'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['merchant_Id'] = merchantId;
    data['merchant_key'] = merchantKey;
    data['cancel_url'] = cancelUrl;
    data['notify_url'] = notifyUrl;
    data['return_url'] = returnUrl;
    data['isEnabled'] = isEnabled;
    data['isSandboxEnabled'] = isSandboxEnabled;
    data['id_payment_method'] = idPaymentMethod;
    data['libelle'] = libelle;
    return data;
  }
}

class PayStack {
  String? id;
  String? secretKey;
  String? publicKey;
  String? callbackUrl;
  String? isEnabled;
  String? isSandboxEnabled;
  String? idPaymentMethod;
  String? libelle;

  PayStack({this.id, this.secretKey, this.publicKey, this.callbackUrl, this.isEnabled, this.isSandboxEnabled, this.idPaymentMethod, this.libelle});

  PayStack.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    secretKey = json['secret_key'].toString();
    publicKey = json['public_key'].toString();
    callbackUrl = json['callback_url'].toString();
    isEnabled = json['isEnabled'].toString();
    isSandboxEnabled = json['isSandboxEnabled'].toString();
    idPaymentMethod = json['id_payment_method'].toString();
    libelle = json['libelle'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['secret_key'] = secretKey;
    data['public_key'] = publicKey;
    data['callback_url'] = callbackUrl;
    data['isEnabled'] = isEnabled;
    data['isSandboxEnabled'] = isSandboxEnabled;
    data['id_payment_method'] = idPaymentMethod;
    data['libelle'] = libelle;
    return data;
  }
}

class FlutterWave {
  String? id;
  String? secretKey;
  String? publicKey;
  String? encryptionKey;
  String? isEnabled;
  String? isSandboxEnabled;
  String? idPaymentMethod;
  String? libelle;

  FlutterWave({this.id, this.secretKey, this.publicKey, this.encryptionKey, this.isEnabled, this.isSandboxEnabled, this.idPaymentMethod, this.libelle});

  FlutterWave.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    secretKey = json['secret_key'].toString();
    publicKey = json['public_key'].toString();
    encryptionKey = json['encryption_key'].toString();
    isEnabled = json['isEnabled'].toString();
    isSandboxEnabled = json['isSandboxEnabled'].toString();
    idPaymentMethod = json['id_payment_method'].toString();
    libelle = json['libelle'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['secret_key'] = secretKey;
    data['public_key'] = publicKey;
    data['encryption_key'] = encryptionKey;
    data['isEnabled'] = isEnabled;
    data['isSandboxEnabled'] = isSandboxEnabled;
    data['id_payment_method'] = idPaymentMethod;
    data['libelle'] = libelle;
    return data;
  }
}

class RazorpayModel {
  String? id;
  String? key;
  String? secretKey;
  String? isEnabled;
  String? isSandboxEnabled;
  String? idPaymentMethod;
  String? libelle;

  RazorpayModel({this.id, this.key, this.secretKey, this.isEnabled, this.isSandboxEnabled, this.idPaymentMethod, this.libelle});

  RazorpayModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    key = json['key'].toString();
    secretKey = json['secret_key'].toString();
    isEnabled = json['isEnabled'].toString();
    isSandboxEnabled = json['isSandboxEnabled'].toString();
    idPaymentMethod = json['id_payment_method'].toString();
    libelle = json['libelle'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['key'] = key;
    data['secret_key'] = secretKey;
    data['isEnabled'] = isEnabled;
    data['isSandboxEnabled'] = isSandboxEnabled;
    data['id_payment_method'] = idPaymentMethod;
    data['libelle'] = libelle;
    return data;
  }
}

class Mercadopago {
  String? id;
  String? publicKey;
  String? accesstoken;
  String? isEnabled;
  String? isSandboxEnabled;
  String? idPaymentMethod;

  Mercadopago({this.id, this.publicKey, this.accesstoken, this.isEnabled, this.isSandboxEnabled, this.idPaymentMethod});

  Mercadopago.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    publicKey = json['public_key'].toString();
    accesstoken = json['accesstoken'].toString();
    isEnabled = json['isEnabled'].toString();
    isSandboxEnabled = json['isSandboxEnabled'].toString();
    idPaymentMethod = json['id_payment_method'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['public_key'] = publicKey;
    data['accesstoken'] = accesstoken;
    data['isEnabled'] = isEnabled;
    data['isSandboxEnabled'] = isSandboxEnabled;
    data['id_payment_method'] = idPaymentMethod;
    return data;
  }
}

class PayPal {
  String? id;
  String? appId;
  String? secretKey;
  String? merchantId;
  String? privateKey;
  String? publicKey;
  String? tokenizationKey;
  String? isEnabled;
  String? isLive;
  String? idPaymentMethod;
  String? username;
  String? password;
  String? libelle;

  PayPal(
      {this.id,
      this.appId,
      this.secretKey,
      this.merchantId,
      this.privateKey,
      this.publicKey,
      this.tokenizationKey,
      this.isEnabled,
      this.isLive,
      this.idPaymentMethod,
      this.username,
      this.password,
      this.libelle});

  PayPal.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    appId = json['app_id'].toString();
    secretKey = json['secret_key'].toString();
    merchantId = json['merchant_Id'].toString();
    privateKey = json['private_key'].toString();
    publicKey = json['public_key'].toString();
    tokenizationKey = json['tokenization_key'].toString();
    isEnabled = json['isEnabled'].toString();
    isLive = json['isLive'].toString();
    idPaymentMethod = json['id_payment_method'].toString();
    username = json['username'].toString();
    password = json['password'].toString();
    libelle = json['libelle'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['app_id'] = appId;
    data['secret_key'] = secretKey;
    data['merchant_Id'] = merchantId;
    data['private_key'] = privateKey;
    data['public_key'] = publicKey;
    data['tokenization_key'] = tokenizationKey;
    data['isEnabled'] = isEnabled;
    data['isLive'] = isLive;
    data['id_payment_method'] = idPaymentMethod;
    data['username'] = username;
    data['password'] = password;
    data['libelle'] = libelle;
    return data;
  }
}

class Xendit {
  String? isEnabled;
  String? libelle;
  String? isSandboxEnabled;
  String? key;
  String? id;
  String? idPaymentMethod;

  Xendit({
    this.libelle,
    this.isEnabled,
    this.key,
    this.isSandboxEnabled,
    this.id,
    this.idPaymentMethod,
  });

  Xendit.fromJson(Map<String, dynamic> json) {
    isEnabled = json['isEnabled'];
    libelle = json['libelle'];
    isSandboxEnabled = json['isSandboxEnabled'];
    key = json['key'];
    id = json['id'];
    idPaymentMethod = json['id_payment_method'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['isEnabled'] = isEnabled;
    data['key'] = key;
    data['id'] = id;
    data['isSandboxEnabled'] = isSandboxEnabled;
    data['libelle'] = libelle;
    data['id_payment_method'] = idPaymentMethod;

    return data;
  }
}

class Midtrans {
  String? isEnabled;
  String? libelle;
  String? isSandboxEnabled;
  String? key;
  String? id;
  String? idPaymentMethod;

  Midtrans({
    this.libelle,
    this.isEnabled,
    this.key,
    this.isSandboxEnabled,
    this.id,
    this.idPaymentMethod,
  });

  Midtrans.fromJson(Map<String, dynamic> json) {
    isEnabled = json['isEnabled'];

    key = json['key'];
    idPaymentMethod = json['idPaymentMethod'];
    libelle = json['libelle'];
    isSandboxEnabled = json['isSandboxEnabled'];

    id = json['id'];
    idPaymentMethod = json['id_payment_method'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['isEnabled'] = isEnabled;
    data['key'] = key;
    data['id'] = id;
    data['isSandboxEnabled'] = isSandboxEnabled;
    data['libelle'] = libelle;
    data['id_payment_method'] = idPaymentMethod;
    return data;
  }
}

class OrangePay {
  String? clientpublishableKey;
  String? clientSecret;
  String? merchantKey;
  String? key;
  String? returnUrl;
  String? cancelUrl;
  String? notifUrl;
  String? libelle;
  String? isEnabled;
  String? isSandboxEnabled;
  String? idPaymentMethod;
  String? id;

  OrangePay(
      {this.clientpublishableKey = '',
      this.clientSecret = '',
      this.merchantKey,
      this.key,
      this.returnUrl = '',
      this.cancelUrl = '',
      this.notifUrl = '',
      this.libelle,
      this.isSandboxEnabled = "",
      this.idPaymentMethod = "",
      this.id,
      this.isEnabled = ""});

  OrangePay.fromJson(Map<String, dynamic> parsedJson) {
    clientpublishableKey = parsedJson['clientpublishableKey'];
    clientSecret = parsedJson['secret_key'];
    merchantKey = parsedJson['merchant_key'];
    key = parsedJson['key'];
    isEnabled = parsedJson['isEnabled'];
    returnUrl = parsedJson['return_url'];
    cancelUrl = parsedJson['cancel_url'];
    notifUrl = parsedJson['notify_url'];
    isSandboxEnabled = parsedJson['isSandboxEnabled'];
    libelle = parsedJson['libelle'];
    id = parsedJson['id'];
    idPaymentMethod = parsedJson['id_payment_method'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['clientpublishableKey'] = clientpublishableKey;
    data['secret_key'] = clientSecret;
    data['merchant_key'] = merchantKey;
    data['key'] = key;
    data['isEnabled'] = isEnabled;
    data['return_url'] = returnUrl;
    data['cancel_url'] = cancelUrl;
    data['notify_url'] = notifUrl;

    data['id'] = id;
    data['isSandboxEnabled'] = isSandboxEnabled;
    data['libelle'] = libelle;
    data['id_payment_method'] = idPaymentMethod;

    return data;
  }
}

class Tax {
  String? id;
  String? name;
  String? taxType;
  String? taxAmount;

  Tax({this.id, this.name, this.taxType, this.taxAmount});

  Tax.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'].toString();
    taxType = json['tax_type'].toString();
    taxAmount = json['tax_amount'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['tax_type'] = taxType;
    data['tax_amount'] = taxAmount;
    return data;
  }
}
