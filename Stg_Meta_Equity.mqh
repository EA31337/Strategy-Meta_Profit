/**
 * @file
 * Implements Equity meta strategy.
 */

// Prevents processing this includes file multiple times.
#ifndef STG_META_EQUITY_MQH
#define STG_META_EQUITY_MQH

// User input params.
INPUT2_GROUP("Meta Equity strategy: main params");
INPUT2 ENUM_STRATEGY Meta_Equity_Strategy_Equity_Normal = STRAT_DEMARKER;  // Strategy for normal equity (-5-5%)
INPUT2 ENUM_STRATEGY Meta_Equity_Strategy_Equity_GT_5 = STRAT_NONE;        // Strategy for high equity (5-10%)
INPUT2 ENUM_STRATEGY Meta_Equity_Strategy_Equity_LT_5 = STRAT_NONE;        // Strategy for low equity (-5-10%)
INPUT2 ENUM_STRATEGY Meta_Equity_Strategy_Equity_GT_10 = STRAT_NONE;       // Strategy for very high equity (>10%)
INPUT2 ENUM_STRATEGY Meta_Equity_Strategy_Equity_LT_10 = STRAT_NONE;       // Strategy for very low equity (<-10%)
INPUT2_GROUP("Meta Equity strategy: common params");
INPUT2 float Meta_Equity_LotSize = 0;                // Lot size
INPUT2 int Meta_Equity_SignalOpenMethod = 0;         // Signal open method
INPUT2 float Meta_Equity_SignalOpenLevel = 0;        // Signal open level
INPUT2 int Meta_Equity_SignalOpenFilterMethod = 32;  // Signal open filter method
INPUT2 int Meta_Equity_SignalOpenFilterTime = 3;     // Signal open filter time (0-31)
INPUT2 int Meta_Equity_SignalOpenBoostMethod = 0;    // Signal open boost method
INPUT2 int Meta_Equity_SignalCloseMethod = 0;        // Signal close method
INPUT2 int Meta_Equity_SignalCloseFilter = 32;       // Signal close filter (-127-127)
INPUT2 float Meta_Equity_SignalCloseLevel = 0;       // Signal close level
INPUT2 int Meta_Equity_PriceStopMethod = 1;          // Price limit method
INPUT2 float Meta_Equity_PriceStopLevel = 2;         // Price limit level
INPUT2 int Meta_Equity_TickFilterMethod = 32;        // Tick filter method (0-255)
INPUT2 float Meta_Equity_MaxSpread = 4.0;            // Max spread to trade (in pips)
INPUT2 short Meta_Equity_Shift = 0;                  // Shift
INPUT2 float Meta_Equity_OrderCloseLoss = 200;       // Order close loss
INPUT2 float Meta_Equity_OrderCloseProfit = 200;     // Order close profit
INPUT2 int Meta_Equity_OrderCloseTime = 2880;        // Order close time in mins (>0) or bars (<0)

// Structs.
// Defines struct with default user strategy values.
struct Stg_Meta_Equity_Params_Defaults : StgParams {
  Stg_Meta_Equity_Params_Defaults()
      : StgParams(::Meta_Equity_SignalOpenMethod, ::Meta_Equity_SignalOpenFilterMethod, ::Meta_Equity_SignalOpenLevel,
                  ::Meta_Equity_SignalOpenBoostMethod, ::Meta_Equity_SignalCloseMethod, ::Meta_Equity_SignalCloseFilter,
                  ::Meta_Equity_SignalCloseLevel, ::Meta_Equity_PriceStopMethod, ::Meta_Equity_PriceStopLevel,
                  ::Meta_Equity_TickFilterMethod, ::Meta_Equity_MaxSpread, ::Meta_Equity_Shift) {
    Set(STRAT_PARAM_LS, ::Meta_Equity_LotSize);
    Set(STRAT_PARAM_OCL, ::Meta_Equity_OrderCloseLoss);
    Set(STRAT_PARAM_OCP, ::Meta_Equity_OrderCloseProfit);
    Set(STRAT_PARAM_OCT, ::Meta_Equity_OrderCloseTime);
    Set(STRAT_PARAM_SOFT, ::Meta_Equity_SignalOpenFilterTime);
  }
};

class Stg_Meta_Equity : public Strategy {
 protected:
  Account account;
  DictStruct<long, Ref<Strategy>> strats;

 public:
  Stg_Meta_Equity(StgParams &_sparams, TradeParams &_tparams, ChartParams &_cparams, string _name = "")
      : Strategy(_sparams, _tparams, _cparams, _name) {}

  static Stg_Meta_Equity *Init(ENUM_TIMEFRAMES _tf = NULL, EA *_ea = NULL) {
    // Initialize strategy initial values.
    Stg_Meta_Equity_Params_Defaults stg_meta_equity_defaults;
    StgParams _stg_params(stg_meta_equity_defaults);
    // Initialize Strategy instance.
    ChartParams _cparams(_tf, _Symbol);
    TradeParams _tparams;
    Strategy *_strat = new Stg_Meta_Equity(_stg_params, _tparams, _cparams, "(Meta) Equity");
    return _strat;
  }

  /**
   * Event on strategy's init.
   */
  void OnInit() {
    StrategyAdd(Meta_Equity_Strategy_Equity_Normal, 1);
    StrategyAdd(Meta_Equity_Strategy_Equity_GT_5, 2);
    StrategyAdd(Meta_Equity_Strategy_Equity_LT_5, 3);
    StrategyAdd(Meta_Equity_Strategy_Equity_GT_10, 4);
    StrategyAdd(Meta_Equity_Strategy_Equity_LT_10, 5);
  }

  /**
   * Sets strategy.
   */
  bool StrategyAdd(ENUM_STRATEGY _sid, long _index) {
    bool _result = true;
    long _magic_no = Get<long>(STRAT_PARAM_ID);
    ENUM_TIMEFRAMES _tf = Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF);

    switch (_sid) {
      case STRAT_NONE:
        break;
      case STRAT_AC:
        _result &= StrategyAdd<Stg_AC>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_AD:
        _result &= StrategyAdd<Stg_AD>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_ADX:
        _result &= StrategyAdd<Stg_ADX>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_AMA:
        _result &= StrategyAdd<Stg_AMA>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_ARROWS:
        _result &= StrategyAdd<Stg_Arrows>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_ASI:
        _result &= StrategyAdd<Stg_ASI>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_ATR:
        _result &= StrategyAdd<Stg_ATR>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_ALLIGATOR:
        _result &= StrategyAdd<Stg_Alligator>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_AWESOME:
        _result &= StrategyAdd<Stg_Awesome>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_BWMFI:
        _result &= StrategyAdd<Stg_BWMFI>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_BANDS:
        _result &= StrategyAdd<Stg_Bands>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_BEARS_POWER:
        _result &= StrategyAdd<Stg_BearsPower>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_BULLS_POWER:
        _result &= StrategyAdd<Stg_BullsPower>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_CCI:
        _result &= StrategyAdd<Stg_CCI>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_CHAIKIN:
        _result &= StrategyAdd<Stg_Chaikin>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_DEMA:
        _result &= StrategyAdd<Stg_DEMA>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_DPO:
        _result &= StrategyAdd<Stg_DPO>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_DEMARKER:
        _result &= StrategyAdd<Stg_DeMarker>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_ENVELOPES:
        _result &= StrategyAdd<Stg_Envelopes>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_FORCE:
        _result &= StrategyAdd<Stg_Force>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_FRACTALS:
        _result &= StrategyAdd<Stg_Fractals>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_GATOR:
        _result &= StrategyAdd<Stg_Gator>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_HEIKEN_ASHI:
        _result &= StrategyAdd<Stg_HeikenAshi>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_ICHIMOKU:
        _result &= StrategyAdd<Stg_Ichimoku>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_INDICATOR:
        _result &= StrategyAdd<Stg_Indicator>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_MA:
        _result &= StrategyAdd<Stg_MA>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_MA_BREAKOUT:
        _result &= StrategyAdd<Stg_MA_Breakout>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_MA_CROSS_PIVOT:
        _result &= StrategyAdd<Stg_MA_Cross_Pivot>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_MA_CROSS_SHIFT:
        _result &= StrategyAdd<Stg_MA_Cross_Shift>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_MA_CROSS_SUP_RES:
        _result &= StrategyAdd<Stg_MA_Cross_Sup_Res>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_MA_TREND:
        _result &= StrategyAdd<Stg_MA_Trend>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_MACD:
        _result &= StrategyAdd<Stg_MACD>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_MFI:
        _result &= StrategyAdd<Stg_MFI>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_MOMENTUM:
        _result &= StrategyAdd<Stg_Momentum>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_OBV:
        _result &= StrategyAdd<Stg_OBV>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_OSCILLATOR:
        _result &= StrategyAdd<Stg_Oscillator>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_OSCILLATOR_DIVERGENCE:
        _result &= StrategyAdd<Stg_Oscillator_Divergence>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_OSCILLATOR_MULTI:
        _result &= StrategyAdd<Stg_Oscillator_Multi>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_OSCILLATOR_CROSS:
        _result &= StrategyAdd<Stg_Oscillator_Cross>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_OSCILLATOR_CROSS_SHIFT:
        _result &= StrategyAdd<Stg_Oscillator_Cross_Shift>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_OSCILLATOR_CROSS_ZERO:
        _result &= StrategyAdd<Stg_Oscillator_Cross_Zero>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_OSCILLATOR_RANGE:
        _result &= StrategyAdd<Stg_Oscillator_Range>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_OSCILLATOR_TREND:
        _result &= StrategyAdd<Stg_Oscillator_Trend>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_OSMA:
        _result &= StrategyAdd<Stg_OsMA>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_PATTERN:
        _result &= StrategyAdd<Stg_Pattern>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_PINBAR:
        _result &= StrategyAdd<Stg_Pinbar>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_PIVOT:
        _result &= StrategyAdd<Stg_Pivot>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_RSI:
        _result &= StrategyAdd<Stg_RSI>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_RVI:
        _result &= StrategyAdd<Stg_RVI>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_SAR:
        _result &= StrategyAdd<Stg_SAR>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_STDDEV:
        _result &= StrategyAdd<Stg_StdDev>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_STOCHASTIC:
        _result &= StrategyAdd<Stg_Stochastic>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_WPR:
        _result &= StrategyAdd<Stg_WPR>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_ZIGZAG:
        _result &= StrategyAdd<Stg_ZigZag>(_tf, _magic_no, _sid, _index);
        break;
      default:
        logger.Warning(StringFormat("Unknown strategy: %d", _sid), __FUNCTION_LINE__, GetName());
        break;
    }

    return _result;
  }

  /**
   * Adds strategy to specific timeframe.
   *
   * @param
   *   _tf - timeframe to add the strategy.
   *   _magic_no - unique order identified
   *
   * @return
   *   Returns true if the strategy has been initialized correctly, otherwise false.
   */
  template <typename SClass>
  bool StrategyAdd(ENUM_TIMEFRAMES _tf, long _magic_no = 0, int _type = 0, long _index = 0) {
    bool _result = true;
    _magic_no = _magic_no > 0 ? _magic_no : rand();
    Ref<Strategy> _strat = ((SClass *)NULL).Init(_tf);
    _strat.Ptr().Set<long>(STRAT_PARAM_ID, _magic_no);
    _strat.Ptr().Set<ENUM_TIMEFRAMES>(STRAT_PARAM_TF, _tf);
    _strat.Ptr().Set<int>(STRAT_PARAM_TYPE, _type);
    _strat.Ptr().OnInit();
    strats.Set(_index, _strat);
    return _result;
  }

  /**
   * Gets price stop value.
   */
  float PriceStop(ENUM_ORDER_TYPE _cmd, ENUM_ORDER_TYPE_VALUE _mode, int _method = 0, float _level = 0.0f,
                  short _bars = 4) {
    float _result = 0;
    if (_method == 0) {
      // Ignores calculation when method is 0.
      return (float)_result;
    }
    float _equity_pct = (float)Math::ChangeInPct(account.GetTotalBalance(), account.AccountEquity());
    Ref<Strategy> _strat_ref;
    if (_equity_pct > -5.0f && _equity_pct < 5.0f) {
      // Equity value is in normal range (between -5% and 5%).
      _strat_ref = strats.GetByKey(1);
    } else if (_equity_pct >= 10.0f) {
      // Equity value is very high (greater than 10%).
      _strat_ref = strats.GetByKey(4);
    } else if (_equity_pct <= -10.0f) {
      // Equity value is very low (lower than 10%).
      _strat_ref = strats.GetByKey(5);
    } else if (_equity_pct >= 5.0f) {
      // Equity value is high (between 5% and 10%).
      _strat_ref = strats.GetByKey(2);
    } else if (_equity_pct <= -5.0f) {
      // Equity value is low (between -5% and -10%).
      _strat_ref = strats.GetByKey(3);
    }

    if (!_strat_ref.IsSet()) {
      // Returns false when strategy is not set.
      return false;
    }

    _level = _level == 0.0f ? _strat_ref.Ptr().Get<float>(STRAT_PARAM_SOL) : _level;
    _method = _strat_ref.Ptr().Get<int>(STRAT_PARAM_SOM);
    //_shift = _shift == 0 ? _strat_ref.Ptr().Get<int>(STRAT_PARAM_SHIFT) : _shift;
    _result = _strat_ref.Ptr().PriceStop(_cmd, _mode, _method, _level /*, _shift*/);
    return (float)_result;
  }

  /**
   * Check strategy's opening signal.
   */
  bool SignalOpen(ENUM_ORDER_TYPE _cmd, int _method, float _level = 0.0f, int _shift = 0) {
    bool _result = true;
    // uint _ishift = _indi.GetShift();
    float _equity_pct = (float)Math::ChangeInPct(account.GetTotalBalance(), account.AccountEquity());
    Ref<Strategy> _strat_ref;
    if (_equity_pct > -5.0f && _equity_pct < 5.0f) {
      // Equity value is in normal range (between -5% and 5%).
      _strat_ref = strats.GetByKey(1);
    } else if (_equity_pct >= 10.0f) {
      // Equity value is very high (greater than 10%).
      _strat_ref = strats.GetByKey(4);
    } else if (_equity_pct <= -10.0f) {
      // Equity value is very low (lower than 10%).
      _strat_ref = strats.GetByKey(5);
    } else if (_equity_pct >= 5.0f) {
      // Equity value is high (between 5% and 10%).
      _strat_ref = strats.GetByKey(2);
    } else if (_equity_pct <= -5.0f) {
      // Equity value is low (between -5% and -10%).
      _strat_ref = strats.GetByKey(3);
    }

    if (!_strat_ref.IsSet()) {
      // Returns false when strategy is not set.
      return false;
    }
    _level = _level == 0.0f ? _strat_ref.Ptr().Get<float>(STRAT_PARAM_SOL) : _level;
    _method = _method == 0 ? _strat_ref.Ptr().Get<int>(STRAT_PARAM_SOM) : _method;
    _shift = _shift == 0 ? _strat_ref.Ptr().Get<int>(STRAT_PARAM_SHIFT) : _shift;
    _result &= _strat_ref.Ptr().SignalOpen(_cmd, _method, _level, _shift);
    return _result;
  }

  /**
   * Check strategy's closing signal.
   */
  bool SignalClose(ENUM_ORDER_TYPE _cmd, int _method, float _level = 0.0f, int _shift = 0) {
    bool _result = false;
    _result = SignalOpen(Order::NegateOrderType(_cmd), _method, _level, _shift);
    return _result;
  }
};

#endif  // STG_META_EQUITY_MQH
