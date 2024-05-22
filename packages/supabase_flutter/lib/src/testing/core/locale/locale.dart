import 'package:supabase_flutter/src/testing/core/currency/currencies.dart';
import 'package:supabase_flutter/src/testing/core/currency/currency.dart';
import 'package:supabase_flutter/src/testing/utils/locale_data.dart';

class Locale {
  Locale._privateConstructor() {
    _initialize();
  }

  static final Locale _instance = Locale._privateConstructor();

  factory Locale() {
    return _instance;
  }

  String _current = Locales.en_US.localeString;
  final List<LocaleData> _localesList = [];

  void setCurrentLocale(Locales locale) =>
      setCurrentLocaleByString(locale.localeString);

  void setCurrentLocaleByString(String localeString) {
    if (!localeExists(localeString)) {
      throw ArgumentError('Locale does not exist.');
    }

    _current = _fetchLocale(localeString).localeString;
  }

  void addLocale(LocaleData locale) {
    if (localeExists(locale.localeString)) {
      throw ArgumentError('Locale already exists.');
    }

    _localesList.add(locale);
  }

  void updateLocale(LocaleData locale) {
    if (localeExists(locale.localeString)) {
      if (locale.localeString == _current) {
        throw ArgumentError(
          'Cannot update if locale is set as current.',
        );
      }
      deleteLocale(locale.localeString);
      addLocale(locale);
    } else {
      throw ArgumentError('Locale does not exist.');
    }
  }

  void deleteLocale(String locale) {
    if (localeExists(locale)) {
      if (locale == _current) {
        throw ArgumentError(
          'Cannot delete if locale is set as current.',
        );
      }
      _deleteLocale(locale);
    } else {
      throw ArgumentError('Locale does not exist.');
    }
  }

  LocaleData getCurrentLocale() {
    return _localesList.firstWhere(
      (element) => element.localeString == _current,
    );
  }

  LocaleData getLocaleByString(String locale) {
    if (localeExists(locale)) {
      return _fetchLocale(locale);
    }

    throw ArgumentError('Locale does not exist.');
  }

  Currency getCurrentCurrency() => getCurrentLocale().currency;

  bool localeExists(String locale) => _localesList.any(
        (element) => element.localeString == locale,
      );

  void reset() {
    _current = 'en_US';
    _localesList.clear();
    _initialize();
  }

  LocaleData _fetchLocale(String locale) => _localesList.firstWhere(
        (element) => element.localeString == locale,
      );

  void _deleteLocale(String locale) {
    _localesList.removeWhere(
      (element) => element.localeString == locale,
    );
  }

  void _initialize() {
    addLocale(
      LocaleData(
        localeString: Locales.af_ZA.localeString,
        localeCurrency: Currencies.zar,
      ),
    );
    addLocale(
      LocaleData(
        localeString: Locales.ar_AE.localeString,
        localeCurrency: Currencies.aed,
      ),
    );
    addLocale(
      LocaleData(
        localeString: Locales.ar_EG.localeString,
        localeCurrency: Currencies.egp,
      ),
    );
    addLocale(
      LocaleData(
        localeString: Locales.ar_MA.localeString,
        localeCurrency: Currencies.mad,
      ),
    );
    addLocale(
      LocaleData(
        localeString: Locales.ar_SA.localeString,
        localeCurrency: Currencies.sar,
      ),
    );
    addLocale(
      LocaleData(
        localeString: Locales.bg_BG.localeString,
        localeCurrency: Currencies.bgn,
      ),
    );
    addLocale(
      LocaleData(
        localeString: Locales.ca_ES.localeString,
        localeCurrency: Currencies.eur,
      ),
    );
    addLocale(
      LocaleData(
        localeString: Locales.cs_CZ.localeString,
        localeCurrency: Currencies.czk,
      ),
    );
    addLocale(
      LocaleData(
        localeString: Locales.da_DK.localeString,
        localeCurrency: Currencies.dkk,
      ),
    );
    addLocale(
      LocaleData(
        localeString: Locales.de_AT.localeString,
        localeCurrency: Currencies.eur,
      ),
    );
    addLocale(
      LocaleData(
        localeString: Locales.de_CH.localeString,
        localeCurrency: Currencies.chf,
      ),
    );
    addLocale(
      LocaleData(
        localeString: Locales.de_DE.localeString,
        localeCurrency: Currencies.eur,
      ),
    );
    addLocale(
      LocaleData(
        localeString: Locales.el_GR.localeString,
        localeCurrency: Currencies.eur,
      ),
    );
    addLocale(
      LocaleData(
        localeString: Locales.en_AU.localeString,
        localeCurrency: Currencies.aud,
      ),
    );
    addLocale(
      LocaleData(
        localeString: Locales.en_CA.localeString,
        localeCurrency: Currencies.cad,
      ),
    );
    addLocale(
      LocaleData(
        localeString: Locales.en_GB.localeString,
        localeCurrency: Currencies.gbp,
      ),
    );
    addLocale(
      LocaleData(
        localeString: Locales.en_IE.localeString,
        localeCurrency: Currencies.eur,
      ),
    );
    addLocale(
      LocaleData(
        localeString: Locales.en_IN.localeString,
        localeCurrency: Currencies.inr,
      ),
    );
    addLocale(
      LocaleData(
        localeString: Locales.en_NZ.localeString,
        localeCurrency: Currencies.nzd,
      ),
    );
    addLocale(
      LocaleData(
        localeString: Locales.en_US.localeString,
        localeCurrency: Currencies.usd,
      ),
    );
    addLocale(
      LocaleData(
        localeString: Locales.en_ZA.localeString,
        localeCurrency: Currencies.zar,
      ),
    );
    addLocale(
      LocaleData(
        localeString: Locales.es_AR.localeString,
        localeCurrency: Currencies.ars,
      ),
    );
    addLocale(
      LocaleData(
        localeString: Locales.es_CL.localeString,
        localeCurrency: Currencies.clp,
      ),
    );
    addLocale(
      LocaleData(
        localeString: Locales.es_CO.localeString,
        localeCurrency: Currencies.cop,
      ),
    );
    addLocale(
      LocaleData(
        localeString: Locales.es_ES.localeString,
        localeCurrency: Currencies.eur,
      ),
    );
    addLocale(
      LocaleData(
        localeString: Locales.es_MX.localeString,
        localeCurrency: Currencies.mxn,
      ),
    );
    addLocale(
      LocaleData(
        localeString: Locales.es_PE.localeString,
        localeCurrency: Currencies.pen,
      ),
    );
    addLocale(
      LocaleData(
        localeString: Locales.es_US.localeString,
        localeCurrency: Currencies.usd,
      ),
    );
    addLocale(
      LocaleData(
        localeString: Locales.et_EE.localeString,
        localeCurrency: Currencies.eur,
      ),
    );
    addLocale(
      LocaleData(
        localeString: Locales.fi_FI.localeString,
        localeCurrency: Currencies.eur,
      ),
    );
    addLocale(
      LocaleData(
        localeString: Locales.fr_BE.localeString,
        localeCurrency: Currencies.eur,
      ),
    );
    addLocale(
      LocaleData(
        localeString: Locales.fr_CA.localeString,
        localeCurrency: Currencies.cad,
      ),
    );
    addLocale(
      LocaleData(
        localeString: Locales.fr_CH.localeString,
        localeCurrency: Currencies.chf,
      ),
    );
    addLocale(
      LocaleData(
        localeString: Locales.fr_FR.localeString,
        localeCurrency: Currencies.eur,
      ),
    );

    addLocale(
      LocaleData(
        localeString: Locales.he_IL.localeString,
        localeCurrency: Currencies.ils,
      ),
    );
    addLocale(
      LocaleData(
        localeString: Locales.hi_IN.localeString,
        localeCurrency: Currencies.inr,
      ),
    );
    addLocale(
      LocaleData(
        localeString: Locales.hr_HR.localeString,
        localeCurrency: Currencies.eur,
      ),
    );
    addLocale(
      LocaleData(
        localeString: Locales.hu_HU.localeString,
        localeCurrency: Currencies.huf,
      ),
    );
    addLocale(
      LocaleData(
        localeString: Locales.id_ID.localeString,
        localeCurrency: Currencies.idr,
      ),
    );
    addLocale(
      LocaleData(
        localeString: Locales.it_CH.localeString,
        localeCurrency: Currencies.chf,
      ),
    );
    addLocale(
      LocaleData(
        localeString: Locales.it_IT.localeString,
        localeCurrency: Currencies.eur,
      ),
    );
    addLocale(
      LocaleData(
        localeString: Locales.ja_JP.localeString,
        localeCurrency: Currencies.jpy,
      ),
    );
    addLocale(
      LocaleData(
        localeString: Locales.ko_KR.localeString,
        localeCurrency: Currencies.krw,
      ),
    );
    addLocale(
      LocaleData(
        localeString: Locales.lt_LT.localeString,
        localeCurrency: Currencies.eur,
      ),
    );
    addLocale(
      LocaleData(
        localeString: Locales.lv_LV.localeString,
        localeCurrency: Currencies.eur,
      ),
    );
    addLocale(
      LocaleData(
        localeString: Locales.ms_MY.localeString,
        localeCurrency: Currencies.myr,
      ),
    );
    addLocale(
      LocaleData(
        localeString: Locales.nb_NO.localeString,
        localeCurrency: Currencies.nok,
      ),
    );
    addLocale(
      LocaleData(
        localeString: Locales.nl_BE.localeString,
        localeCurrency: Currencies.eur,
      ),
    );
    addLocale(
      LocaleData(
        localeString: Locales.nl_NL.localeString,
        localeCurrency: Currencies.eur,
      ),
    );
    addLocale(
      LocaleData(
        localeString: Locales.pl_PL.localeString,
        localeCurrency: Currencies.pln,
      ),
    );
    addLocale(
      LocaleData(
        localeString: Locales.pt_BR.localeString,
        localeCurrency: Currencies.brl,
      ),
    );
    addLocale(
      LocaleData(
        localeString: Locales.pt_PT.localeString,
        localeCurrency: Currencies.eur,
      ),
    );
    addLocale(
      LocaleData(
        localeString: Locales.ro_RO.localeString,
        localeCurrency: Currencies.ron,
      ),
    );
    addLocale(
      LocaleData(
        localeString: Locales.ru_RU.localeString,
        localeCurrency: Currencies.rub,
      ),
    );
    addLocale(
      LocaleData(
        localeString: Locales.sk_SK.localeString,
        localeCurrency: Currencies.eur,
      ),
    );
    addLocale(
      LocaleData(
        localeString: Locales.sl_SL.localeString,
        localeCurrency: Currencies.eur,
      ),
    );
    addLocale(
      LocaleData(
        localeString: Locales.sr_RS.localeString,
        localeCurrency: Currencies.rsd,
      ),
    );
    addLocale(
      LocaleData(
        localeString: Locales.sv_SE.localeString,
        localeCurrency: Currencies.sek,
      ),
    );
    addLocale(
      LocaleData(
        localeString: Locales.th_TH.localeString,
        localeCurrency: Currencies.thb,
      ),
    );
    addLocale(
      LocaleData(
        localeString: Locales.tr_TR.localeString,
        localeCurrency: Currencies.try_,
      ),
    );
    addLocale(
      LocaleData(
        localeString: Locales.uk_UA.localeString,
        localeCurrency: Currencies.uah,
      ),
    );
    addLocale(
      LocaleData(
        localeString: Locales.vi_VN.localeString,
        localeCurrency: Currencies.vnd,
      ),
    );
    addLocale(
      LocaleData(
        localeString: Locales.zh_CN.localeString,
        localeCurrency: Currencies.cny,
      ),
    );
    addLocale(
      LocaleData(
        localeString: Locales.zh_HK.localeString,
        localeCurrency: Currencies.hkd,
      ),
    );
    addLocale(
      LocaleData(
        localeString: Locales.zh_TW.localeString,
        localeCurrency: Currencies.twd,
      ),
    );
  }
}

class LocaleData {
  final String localeString;
  final Currency currency;

  LocaleData({
    required this.localeString,
    Currency? localeCurrency,
  }) : currency = localeCurrency ?? Currencies.usd;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! LocaleData) return false;
    return localeString == other.localeString && currency == other.currency;
  }

  @override
  int get hashCode => Object.hash(localeString, currency);
}
