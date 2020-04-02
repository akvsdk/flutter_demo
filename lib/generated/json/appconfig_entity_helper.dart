import 'package:flutterdemo/bean/appconfig_entity.dart';

appconfigEntityFromJson(AppconfigEntity data, Map<String, dynamic> json) {
	if (json['version'] != null) {
		data.version = json['version']?.toString();
	}
	if (json['platform'] != null) {
		data.platform = json['platform']?.toString();
	}
	if (json['showupdate'] != null) {
		data.showupdate = json['showupdate']?.toInt();
	}
	if (json['needupdate'] != null) {
		data.needupdate = json['needupdate']?.toInt();
	}
	if (json['updateurl'] != null) {
		data.updateurl = json['updateurl']?.toString();
	}
	if (json['updatecontent'] != null) {
		data.updatecontent = json['updatecontent']?.toString();
	}
	if (json['invitestring'] != null) {
		data.invitestring = json['invitestring']?.toString();
	}
	if (json['informstring'] != null) {
		data.informstring = json['informstring']?.toString();
	}
	if (json['hasupdate'] != null) {
		data.hasupdate = json['hasupdate']?.toInt();
	}
	if (json['apkurl'] != null) {
		data.apkurl = json['apkurl']?.toString();
	}
	if (json['alipayenable'] != null) {
		data.alipayenable = json['alipayenable']?.toInt();
	}
	if (json['isshowprivacy'] != null) {
		data.isshowprivacy = json['isshowprivacy']?.toString();
	}
	if (json['isshowAudio'] != null) {
		data.isshowAudio = json['isshowAudio']?.toString();
	}
	if (json['isshowMFTransfer'] != null) {
		data.isshowMFTransfer = json['isshowMFTransfer']?.toString();
	}
	if (json['isshowTransfer'] != null) {
		data.isshowTransfer = json['isshowTransfer']?.toString();
	}
	if (json['isshowHFRP'] != null) {
		data.isshowHFRP = json['isshowHFRP']?.toString();
	}
	if (json['isshowFiveUPayRP'] != null) {
		data.isshowFiveUPayRP = json['isshowFiveUPayRP']?.toString();
	}
	if (json['isshowMFRP'] != null) {
		data.isshowMFRP = json['isshowMFRP']?.toString();
	}
	return data;
}

Map<String, dynamic> appconfigEntityToJson(AppconfigEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['version'] = entity.version;
	data['platform'] = entity.platform;
	data['showupdate'] = entity.showupdate;
	data['needupdate'] = entity.needupdate;
	data['updateurl'] = entity.updateurl;
	data['updatecontent'] = entity.updatecontent;
	data['invitestring'] = entity.invitestring;
	data['informstring'] = entity.informstring;
	data['hasupdate'] = entity.hasupdate;
	data['apkurl'] = entity.apkurl;
	data['alipayenable'] = entity.alipayenable;
	data['isshowprivacy'] = entity.isshowprivacy;
	data['isshowAudio'] = entity.isshowAudio;
	data['isshowMFTransfer'] = entity.isshowMFTransfer;
	data['isshowTransfer'] = entity.isshowTransfer;
	data['isshowHFRP'] = entity.isshowHFRP;
	data['isshowFiveUPayRP'] = entity.isshowFiveUPayRP;
	data['isshowMFRP'] = entity.isshowMFRP;
	return data;
}