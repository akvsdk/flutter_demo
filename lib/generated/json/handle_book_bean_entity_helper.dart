import 'package:flutterdemo/bean/handle_book_bean_entity.dart';

handleBookBeanEntityFromJson(HandleBookBeanEntity data, Map<String, dynamic> json) {
	if (json['bookNum'] != null) {
		data.bookNum = json['bookNum']?.toInt();
	}
	if (json['bookName'] != null) {
		data.bookName = json['bookName']?.toString();
	}
	if (json['bookUrl'] != null) {
		data.bookUrl = json['bookUrl']?.toString();
	}
	if (json['bookDesc'] != null) {
		data.bookDesc = json['bookDesc']?.toString();
	}
	if (json['rightAnswer'] != null) {
		data.rightAnswer = json['rightAnswer']?.toInt();
	}
	if (json['leftAnswer'] != null) {
		data.leftAnswer = json['leftAnswer']?.toInt();
	}
	if (json['correctAnswer'] != null) {
		data.correctAnswer = json['correctAnswer']?.toInt();
	}
	if (json['difficulty'] != null) {
		data.difficulty = json['difficulty']?.toInt();
	}
	return data;
}

Map<String, dynamic> handleBookBeanEntityToJson(HandleBookBeanEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['bookNum'] = entity.bookNum;
	data['bookName'] = entity.bookName;
	data['bookUrl'] = entity.bookUrl;
	data['bookDesc'] = entity.bookDesc;
	data['rightAnswer'] = entity.rightAnswer;
	data['leftAnswer'] = entity.leftAnswer;
	data['correctAnswer'] = entity.correctAnswer;
	data['difficulty'] = entity.difficulty;
	return data;
}