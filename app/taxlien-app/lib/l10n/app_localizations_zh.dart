// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'TaxLien Swipe';

  @override
  String get profileTitle => '专家个人资料';

  @override
  String get language => '语言';

  @override
  String get settings => '设置';

  @override
  String get roles => '角色';

  @override
  String get switchProfile => '切换个人资料';

  @override
  String get retry => '重试';

  @override
  String get startOver => '重新开始';

  @override
  String get noMoreProperties => '没有更多房产！';

  @override
  String get checkBackLater => '稍后回来查看新列表';

  @override
  String get dailyLimitReached => '达到每日限制';

  @override
  String get maybeLater => '以后再说';

  @override
  String get upgradeNow => '现在升级';

  @override
  String get expert => '专家';

  @override
  String get foreclosureMode => '法拍模式';

  @override
  String get hintFviTitle => 'FVI';

  @override
  String get hintFviBody => 'FVI 显示对您家庭的价值。点击徽章查看详情。';

  @override
  String get hintForeclosureTitle => '法拍 %';

  @override
  String get hintForeclosureBody => '获得房产的概率。85%+ = 高概率。';

  @override
  String get hintFilterTitle => '筛选';

  @override
  String get hintFilterBody => '使用筛选找到最佳法拍匹配。';

  @override
  String get hintGotIt => '知道了';

  @override
  String get hintDontShowAgain => '不再显示';

  @override
  String get disableAllHints => '禁用所有提示';

  @override
  String get showHints => '显示提示';

  @override
  String get nudgeExpertModeTitle => '想要更多？';

  @override
  String get nudgeExpertModeBody => '试试专家模式获得更多控制。';

  @override
  String get nudgeAnnotationTitle => '做标记';

  @override
  String get nudgeAnnotationBody => '在照片上为家人添加标注。';

  @override
  String get nudgeForeclosureFilterTitle => '缩小范围';

  @override
  String get nudgeForeclosureFilterBody => '用法拍筛选获得更好匹配。';

  @override
  String get nudgeFamilyBoardTitle => '看看家人找到了什么';

  @override
  String get nudgeFamilyBoardBody => '在家庭看板查看共享房产。';

  @override
  String get nudgeTryIt => '试试';

  @override
  String get nudgeNotNow => '暂不';

  @override
  String get nudgeDefaultTitle => '提示';

  @override
  String get nudgeDefaultBody => '试试这个功能。';

  @override
  String get dealDetective => 'DEAL DETECTIVE';

  @override
  String get welcomeSubtitle => '以最佳价格\n找到法拍房产';

  @override
  String get startSetup => '开始设置';

  @override
  String get orDivider => '或';

  @override
  String get skipKnowSwipe => '我已经会滑动了';

  @override
  String get hintsOff => '提示已关闭';

  @override
  String get tapToTurnOffHints => '点击关闭所有提示';

  @override
  String get expertProfileSwitcher => '专家档案切换';

  @override
  String get rolesList => '角色：Khun Pho, Denis, Anton, Vasilisa';

  @override
  String get account => '账户';

  @override
  String get notSignedIn => '未登录';

  @override
  String get signIn => '登录';

  @override
  String get signOut => '退出';

  @override
  String get deleteAccount => '删除账户';

  @override
  String get signedOut => '已退出';

  @override
  String get deleteAccountConfirm => '确定吗？这将删除您的账户和云端数据。本地数据可能保留。';

  @override
  String get cancel => '取消';

  @override
  String get delete => '删除';

  @override
  String get accountDeleted => '账户已删除';

  @override
  String get signInAgain => '重新登录';

  @override
  String get deleteAccountSignInAgain => '要删除账户，请先退出，再重新登录后尝试「删除账户」。';

  @override
  String get ok => '确定';

  @override
  String get couldNotDeleteAccount => '无法删除账户，请重试。';

  @override
  String get achievements => '成就';

  @override
  String get undoLimitReached => '已达撤销上限';

  @override
  String get upgradeToPremium => '升级至高级版';

  @override
  String resetIn(String time) {
    return '重置时间：$time';
  }

  @override
  String get foreclosureModeOn => '法拍模式：开';

  @override
  String get foreclosureModeOff => '法拍模式：关';
}
