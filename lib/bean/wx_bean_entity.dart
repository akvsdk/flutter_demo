import 'package:flutterdemo/generated/json/base/json_convert_content.dart';

class WxBeanEntity with JsonConvert<WxBeanEntity> {
	List<dynamic> children;
	int courseId;
	int id;
	String name;
	int order;
	int parentChapterId;
	bool userControlSetTop;
	int visible;
}
