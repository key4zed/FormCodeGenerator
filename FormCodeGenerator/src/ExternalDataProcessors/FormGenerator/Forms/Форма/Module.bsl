#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	МассивИменФорм = Новый Массив;
	
	Формы = РеквизитФормыВЗначение("Объект").Метаданные().Формы;
	Для каждого Форма Из Формы Цикл
		Если Форма.Имя <> "Форма" Тогда
			Элементы.ИмяФормыНовая.СписокВыбора.Добавить(Форма.Имя);
			Элементы.ИмяФормыИсходная.СписокВыбора.Добавить(Форма.Имя);
			МассивИменФорм.Добавить(Форма.Имя);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого Эл Из МассивИменФорм Цикл
		ЭлПоиска = СокрЛП(Эл)+"1";
		Если МассивИменФорм.Найти(ЭлПоиска) <> Неопределено Тогда
			ИмяФормыИсходная = Эл;
			ИмяФормыНовая = ЭлПоиска;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Сравнить(Команда)
	
	ФормаОбработкиСтарая = ПолучитьФорму("ВнешняяОбработка.FormGenerator.Форма."+ИмяФормыИсходная, , ЭтаФорма);	
	РеквизитыСтарые = Неопределено;
    ЭлементыСтарые = Неопределено;
    РеквизитыЭлеиентыФормы(ФормаОбработкиСтарая, РеквизитыСтарые, ЭлементыСтарые);

	ФормаОбработкиНовая = ПолучитьФорму("ВнешняяОбработка.FormGenerator.Форма."+ИмяФормыНовая, , ЭтаФорма);		
	РеквизитыНовые = Неопределено;
	ЭлементыНовые = Неопределено;
    РеквизитыЭлеиентыФормы(ФормаОбработкиНовая, РеквизитыНовые, ЭлементыНовые);

    СтруктураМассивов = СтруктураДобавленныхПолученныхЭлементовГрупп(ЭлементыНовые, ЭлементыСтарые);
    МассивДобавленныхГрупп = СтруктураМассивов.МассивДобавленныхГрупп;
	МассивДобавленных = СтруктураМассивов.МассивДобавленных;
    МассивКУдалению = СтруктураМассивов.МассивКУдалению;
	
	РеквизитыФормыНовые = РеквизитыНовые.РеквизитыФормы;
	ЭлементыПутьКДаннымНовые = РеквизитыНовые.ЭлементыПутьКДанным;
	
	РеквизитыФормыСтарые = РеквизитыСтарые.РеквизитыФормы;
	ЭлементыПутьКДаннымСтарые = РеквизитыСтарые.ЭлементыПутьКДанным;	
	
	ДобавленныеРеквизитыФормы = ПолучитьДобавленныеРеквизитыФормы(РеквизитыФормыНовые, РеквизитыФормыСтарые);

	
	ТекстДобавленияРеквизитов = ТекстДобавленияРеквизитов(ДобавленныеРеквизитыФормы); 
	ТекстДобавленияЭлементов = ТекстДобавленияЭлементов(МассивДобавленных); 
	ТекстДобавленияГрупп = ТекстДобавленияГрупп(МассивДобавленныхГрупп, МассивКУдалению);
	
	Объект.ТекстПрограммногоДобавления = ТекстДобавленияРеквизитов + ТекстДобавленияГрупп;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьДобавленныеРеквизитыФормы(Знач РеквизитыФормыНовые, Знач РеквизитыФормыСтарые)
	
	Перем ДобавленныеРеквизитыФормы, Эл;
	
	ДобавленныеРеквизитыФормы = Новый Структура;
	Для Каждого Эл Из РеквизитыФормыНовые Цикл
		Если РеквизитыФормыСтарые.Свойство(Эл.Ключ) = Ложь Тогда
			ДобавленныеРеквизитыФормы.Вставить(Эл.Ключ, Эл.Значение);
		КонецЕсли;
	КонецЦикла;
	Возврат ДобавленныеРеквизитыФормы;

КонецФункции

&НаКлиенте
Процедура РеквизитыЭлеиентыФормы(ФормаОбработки, Реквизиты, Элементы)
		
	Реквизиты = Новый Структура;
	ФормаОбработки.Открыть();
	Реквизиты = ФормаОбработки.ПолучитьРеквизитыФормы();
	ФормаОбработки.Закрыть();	
	Элементы = ФормаОбработки.Элементы;

КонецПроцедуры

&НаКлиенте
Функция ТекстДобавленияГрупп(МассивДобавленныхГрупп, МассивКУдалению)
	
	СоответствиеДобавляемыхГрупп = Новый Соответствие;
	
	н = 0;
	Приоритет = 0;
	Пока МассивДобавленныхГрупп.Количество() <> 0 Цикл
		
		Элемент = МассивДобавленныхГрупп[н]; 
		
		Если НайденРодительГруппы(Элемент, МассивКУдалению, ТаблицаДобавляемыхГрупп) Тогда
			МассивДобавленныхГрупп.Удалить(н);
			НоваяСтрока = ТаблицаДобавляемыхГрупп.Добавить();
			НоваяСтрока.Приоритет = Приоритет;
			НоваяСтрока.ИмяГруппы = Элемент.Имя;
			
			Если ТипЗнч(Элемент.Родитель) <> Тип("ФормаКлиентскогоПриложения") Тогда
				НоваяСтрока.ИмяРодитель = Элемент.Родитель.Имя;
			КонецЕсли;
			
			СоответствиеДобавляемыхГрупп.Вставить(Элемент.Имя, Элемент);
			Приоритет = Приоритет + 1;
			Продолжить;
		КонецЕсли;
		
		Если н = МассивДобавленныхГрупп.Количество()-1 Тогда
			Приоритет = Приоритет + 1;
			н = 0;
			Продолжить;
		КонецЕсли;
		н = н + 1;
	КонецЦикла;
	
	ТаблицаДобавляемыхГрупп.Сортировать("Приоритет Возр");
	
	ТекстДобавленияГрупп = СгенерироватьТекстДобавленияГрупп(СоответствиеДобавляемыхГрупп);
	Возврат ТекстДобавленияГрупп;

КонецФункции

&НаКлиенте
Функция СтруктураДобавленныхПолученныхЭлементовГрупп(ЭлементыНовые,ЭлементыСтарые)
	
	МассивКУдалению = Новый Массив;
	МассивДобавленных = Новый Массив;
	МассивДобавленныхГрупп = Новый Массив;

	Для Каждого НовыйЭлемент Из ЭлементыНовые Цикл
		НайденныйСтарый = ЭлементыСтарые.Найти(НовыйЭлемент.Имя);
		Если НайденныйСтарый = Неопределено Тогда
			
			Если ТипЗнч(НовыйЭлемент) = Тип("ГруппаФормы")
				И НовыйЭлемент.Вид <> ВидГруппыФормы.КонтекстноеМеню Тогда
				МассивДобавленныхГрупп.Добавить(НовыйЭлемент);
			Иначе
				МассивДобавленных.Добавить(НовыйЭлемент);
			КонецЕсли;
			
		Иначе
			
			МассивКУдалению.Добавить(НайденныйСтарый);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Новый Структура("МассивКУдалению, МассивДобавленных, МассивДобавленныхГрупп", 
							МассивКУдалению, МассивДобавленных, МассивДобавленныхГрупп);

КонецФункции


&НаКлиенте
Функция СгенерироватьТекстДобавленияГрупп(СоответствиеДобавляемыхГрупп)
	
	ТекстДобавления = "";
	ТекстКонтекст = "%КонтекстГруппы% = РедакторФорм.СоздатьКонтекстЭлемента(ЭтотОбъект);";	
	ТекстПараметр = "%КонтекстГруппы%.Свойства.Вставить(""%ИмяПараметра%"", %ЗначениеПараметра%);";
	ТекстГруппа = "%ИмяГруппы% = РедакторФорм.ДобавитьГруппуНаФорму(%КонтекстГруппы%, ""%ИмяГруппы%"");";
	
	Для Каждого СтрокаГруппа Из ТаблицаДобавляемыхГрупп Цикл
		
		ИмяГруппы = СтрокаГруппа.ИмяГруппы;
		
		ГрТекстКонтекст = СтрЗаменить(ТекстКонтекст, "%КонтекстГруппы%", "Контекст" + ИмяГруппы);
		ТекстДобавления = ТекстДобавления + Символы.ПС + ГрТекстКонтекст + Символы.ПС;
		
		Если ЗначениеЗаполнено(СтрокаГруппа.ИмяРодитель) Тогда
			ГрТекстПараметр = СтрЗаменить(ТекстПараметр, "%КонтекстГруппы%", "Контекст" + ИмяГруппы);
			ГрТекстПараметр = СтрЗаменить(ГрТекстПараметр, "%ИмяПараметра%", "Родитель");
			ГрТекстПараметр = СтрЗаменить(ГрТекстПараметр, "%ЗначениеПараметра%", "Элементы." + СтрокаГруппа.ИмяРодитель);
			ТекстДобавления = ТекстДобавления + ГрТекстПараметр + Символы.ПС;
		КонецЕсли;
				
		ГрТекстГруппа = СтрЗаменить(ТекстГруппа, "%КонтекстГруппы%", "Контекст" + ИмяГруппы);
		ГрТекстГруппа = СтрЗаменить(ГрТекстГруппа, "%ИмяГруппы%", ИмяГруппы);
		ТекстДобавления = ТекстДобавления + ГрТекстГруппа + Символы.ПС;
		
	КонецЦикла;
	  
	Возврат ТекстДобавления;  
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция НайденРодительГруппы(ГруппаПоискаРодителя, МассивПоиска, ТаблицаНайденных)
	
	Найден = Ложь;
	Если ТипЗнч(ГруппаПоискаРодителя.Родитель) = Тип("ФормаКлиентскогоПриложения") Тогда
		Найден = Истина;
		Возврат Найден;
	КонецЕсли;
		
	Для Каждого Элемент Из МассивПоиска Цикл
		Если ГруппаПоискаРодителя.Родитель.Имя = Элемент.Имя Тогда
			Найден = Истина;	
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого Строка Из ТаблицаНайденных Цикл
		Если ГруппаПоискаРодителя.Родитель.Имя = Строка.ИмяГруппы Тогда
			Найден = Истина;	
		КонецЕсли;
	КонецЦикла;
	
	
	Возврат Найден;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ТекстДобавленияЭлементов(МассивДобавленных)
	
	ТекстДобавления = "";
	ТекстКонтекст = "КонтекстГруппы = РедакторФорм.СоздатьКонтекстЭлемента(ЭтотОбъект);";	
	ТекстПараметр = "КонтекстГруппы.Свойства.Вставить(""%ИмяПараметра%"", ""%ЗначениеПараметра%"");";
	ТекстГруппа = "Группа = РедакторФорм.ДобавитьГруппуНаФорму(КонтекстГруппы, %ИмяГруппы%);";
	
	
	Для Каждого ДобавленныйЭлемент Из МассивДобавленных Цикл
		Если ТипЗнч(ДобавленныйЭлемент) = Тип("ГруппаФормы") Тогда
			
		КонецЕсли;		
	КонецЦикла;
	
	                                                                        
	Возврат ТекстДобавления; 

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ТекстДобавленияРеквизитов(СтруктураРеквизитов)
	
	ТекстНачало = "МассивДобавляемыхРеквизитов = Новый Массив;
	|";
	СекцияРеквизита = "
	|НовыйРеквизит = Новый РеквизитФормы(""%ИмяРеквизита%"", Тип(""%Тип%""), ""%ПутьРеквизитов%"");
	|МассивДобавляемыхРеквизитов.Добавить(НовыйРеквизит);
	|";	
	ТекстКонец = "
	|Форма.ИзменитьРеквизиты(МассивДобавляемыхРеквизитов);";
	ТекстДобавления = "";
	
	Если СтруктураРеквизитов.Количество() > 0 Тогда
		
		ТекстДобавления = ТекстНачало;
		
		Для Каждого Эл Из СтруктураРеквизитов Цикл
			
			ТекстЭлемент = СекцияРеквизита;
			ТекстЭлемент = СтрЗаменить(СекцияРеквизита, "%ИмяРеквизита%", Эл.Ключ);
			ТекстЭлемент = СтрЗаменить(ТекстЭлемент, "%Тип%", Эл.Значение.ТипЗначения);
			ТекстЭлемент = СтрЗаменить(ТекстЭлемент, "%ПутьРеквизитов%", Эл.Значение.Путь);
			
			ТекстДобавления = ТекстДобавления + ТекстЭлемент ;
			
		КонецЦикла;
		
		ТекстДобавления = ТекстДобавления + ТекстКонец;
	КонецЕсли;
	
	Возврат ТекстДобавления; 

КонецФункции

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	н=1;
	
КонецПроцедуры

#КонецОбласти
