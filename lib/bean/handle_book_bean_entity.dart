import 'package:flutterdemo/generated/json/base/json_convert_content.dart';

class HandleBookBeanEntity with JsonConvert<HandleBookBeanEntity> {
	int bookNum;
	String bookName;
	String bookUrl;
	String bookDesc;
	int rightAnswer;
	int leftAnswer;
	int correctAnswer;
	int difficulty;
}
