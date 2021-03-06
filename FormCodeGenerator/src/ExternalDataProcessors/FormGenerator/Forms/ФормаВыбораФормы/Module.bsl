#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ТекущаяСтрока") Тогда
		Если ЗначениеЗаполнено(Параметры.ТекущаяСтрока) Тогда
			ФормаАнализируемая = Параметры.ТекущаяСтрока;
			Параметры.Свойство("ФормаИмяОбъекта", ФормаИмяОбъекта);
			Параметры.Свойство("ФормаТипОбъекта", ФормаТипОбъекта);
			Параметры.Свойство("ФормаИмяФормы", ФормаИмяФормы);	
		КонецЕсли;
	КонецЕсли;
	
	ЗаполнитьДеревоФорм(); 

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
		//Развернуть дерево
		Для Каждого Строка Из Объект.ДеревоФорм.ПолучитьЭлементы() Цикл    
			Если Строка.Имя = ФормаТипОбъекта Тогда
				//Ищем объект
				Для Каждого СтрокаОбъект Из Строка.ПолучитьЭлементы() Цикл    
					Если СтрокаОбъект.Имя = ФормаИмяОбъекта Тогда
						//Ищем форму
						Для Каждого СтрокаФормы Из СтрокаОбъект.ПолучитьЭлементы() Цикл    
							Если СтрокаФормы.Имя = ФормаИмяФормы Тогда
								ИдентификаторСтроки = СтрокаФормы.ПолучитьИдентификатор();
								Элементы.ОбъектДеревоФорм.ТекущаяСтрока = ИдентификаторСтроки;	
							КонецЕсли; 
						КонецЦикла;
					КонецЕсли; 
				КонецЦикла;
			КонецЕсли; 
		КонецЦикла;
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементов

&НаКлиенте
Процедура ОбъектДеревоФормВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ВыбраннаяСтрока = Неопределено Тогда	
		Возврат;
	КонецЕсли; 
	
	ТекСтрока = Объект.ДеревоФорм.НайтиПоИдентификатору(ВыбраннаяСтрока);
	Если НЕ ПустаяСтрока(ТекСтрока.ПолныйПутьКФорме) Тогда
		
		//Имя справочника, имя документа, ....
		РодительФормы = ТекСтрока.ПолучитьРодителя();
		//Справочник, документ,....
		ТипОбъекта = РодительФормы.ПолучитьРодителя();
		
		СтруктИнфыОМетаданном = Новый Структура;
		СтруктИнфыОМетаданном.Вставить("ТипОбъекта",ТипОбъекта.Имя);
		СтруктИнфыОМетаданном.Вставить("ИмяОбъекта",РодительФормы.Имя);
		СтруктИнфыОМетаданном.Вставить("ИмяФормы",ТекСтрока.Имя);
		СтруктИнфыОМетаданном.Вставить("ПолныйПутьКФорме",ТекСтрока.ПолныйПутьКФорме);
		
		Закрыть(СтруктИнфыОМетаданном);
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьДеревоФорм() Экспорт
	
	ДеревоФорм = РеквизитФормыВЗначение("Объект.ДеревоФорм");
	
	ЗаполнитьДеревоФормПоМетаданным(ДеревоФорм, "Справочники");
	ЗаполнитьДеревоФормПоМетаданным(ДеревоФорм, "Документы");
	ЗаполнитьДеревоФормПоМетаданным(ДеревоФорм, "ЖурналыДокументов");
	ЗаполнитьДеревоФормПоМетаданным(ДеревоФорм, "Отчеты");
	ЗаполнитьДеревоФормПоМетаданным(ДеревоФорм, "Обработки");
	ЗаполнитьДеревоФормПоМетаданным(ДеревоФорм, "ПланыВидовХарактеристик");
	ЗаполнитьДеревоФормПоМетаданным(ДеревоФорм, "ПланыСчетов");
	ЗаполнитьДеревоФормПоМетаданным(ДеревоФорм, "ПланыВидовРасчета");
	ЗаполнитьДеревоФормПоМетаданным(ДеревоФорм, "РегистрыСведений");
	ЗаполнитьДеревоФормПоМетаданным(ДеревоФорм, "РегистрыНакопления");
	ЗаполнитьДеревоФормПоМетаданным(ДеревоФорм, "РегистрыБухгалтерии");
	ЗаполнитьДеревоФормПоМетаданным(ДеревоФорм, "РегистрыРасчета");
	ЗаполнитьДеревоФормПоМетаданным(ДеревоФорм, "БизнесПроцессы");
	ЗаполнитьДеревоФормПоМетаданным(ДеревоФорм, "Задачи");
	
	ЗначениеВРеквизитФормы(ДеревоФорм, "Объект.ДеревоФорм");
КонецПроцедуры

Процедура ЗаполнитьДеревоФормПоМетаданным(СтрокиМетаданные, СтрМетаданные)
	Строки = СтрокиМетаданные.Строки.Добавить();
	Строки.Имя = СтрМетаданные;
	Для каждого стр из Метаданные[СтрМетаданные] Цикл
		стрДерева = Строки.Строки.Добавить();
		стрДерева.Имя = стр.Имя;	
		Для каждого Форма из стр.Формы Цикл
			Если Строка(Форма.ТипФормы)="Управляемая" Тогда
				стрФорм = стрДерева.Строки.Добавить();
				стрФорм.Имя = Форма.Имя;
				стрФорм.ПолныйПутьКФорме = стр.ПолноеИмя()+".Форма."+Форма.Имя;
			КонецЕсли;
		КонецЦикла;	
	КонецЦикла;	
КонецПроцедуры


#КонецОбласти