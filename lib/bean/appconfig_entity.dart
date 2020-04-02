import 'package:flutterdemo/generated/json/base/json_convert_content.dart';

class AppconfigEntity with JsonConvert<AppconfigEntity> {
	String version;
	String platform;
	int showupdate;
	int needupdate;
	String updateurl;
	String updatecontent;
	String invitestring;
	String informstring;
	int hasupdate;
	String apkurl;
	int alipayenable;
	String isshowprivacy;
	String isshowAudio;
	String isshowMFTransfer;
	String isshowTransfer;
	String isshowHFRP;
	String isshowFiveUPayRP;
	String isshowMFRP;
}
