Процедура ПодготовитьДанныеАнализируемойФормы(Форма) Экспорт
	
	Если Форма.Параметры.Свойство("РедакторФорм") Тогда
	
		СтруктураПутейКРеквизитам = Новый Структура;
		ПараметрыФорм = Новый Структура("ФормаОбразец",Форма);
					
		НастройкиРедакторФорм = Форма.Параметры.РедакторФорм;
		ПараметрыРедакторФорм = ПолучитьИзВременногоХранилища(НастройкиРедакторФорм.АдресВоВременномХранилище);
		
		СоответствиеТекстовыхПредставлений = ПараметрыРедакторФорм.СоответствиеТекстовыхПредставлений;
		СоответствиеПредставленийТипов = ПараметрыРедакторФорм.СоответствиеПредставленийТипов;		
		
		//Добавим элементы командной панели
		НоваяСтрока = ПараметрыРедакторФорм.ДеревоЭлементов.Строки.Добавить();
		НоваяСтрока.Имя = "ФормаКоманднаяПанель";
		НоваяСтрока.Тип = Тип(Форма.КоманднаяПанель);
		СформироватьДеревоСЭлементамиФормы(НоваяСтрока, Форма.КоманднаяПанель.ПодчиненныеЭлементы, СтруктураПутейКРеквизитам);
		
		//Добавим подчиненные элементы форм
		СформироватьДеревоСЭлементамиФормы(ПараметрыРедакторФорм.ДеревоЭлементов, Форма.ПодчиненныеЭлементы, СтруктураПутейКРеквизитам);
		СформироватьКодПоСтрокам(ПараметрыРедакторФорм.ДеревоЭлементов, ПараметрыФорм);
				
		
		СформироватьДеревоСРеквизитамиФормы(ПараметрыРедакторФорм.ДеревоРеквизитов, "", Форма, Форма, СтруктураПутейКРеквизитам);
		
		ЗначениеВФайл(НастройкиРедакторФорм.ИмяВременногоФайла, ПараметрыРедакторФорм);
		 				
		Возврат;
		
	КонецЕсли; 
	
КонецПроцедуры

Процедура СформироватьДеревоСЭлементамиФормы(ДеревоЭлементов,ТекКоллекция, СтруктураПутейКРеквизитам) Экспорт
	
	Для каждого ТекЭлемент Из ТекКоллекция Цикл
		ТипЗначениеЭлемента = Тип(ТекЭлемент);
		
		НоваяСтрока = ДеревоЭлементов.Строки.Добавить();
		НоваяСтрока.Имя = ТекЭлемент.Имя;
		НоваяСтрока.Тип = ТипЗначениеЭлемента;
		ПутьКДанным = "";
		
		Если ТипЗначениеЭлемента = Тип("ГруппаФормы") Тогда
			СформироватьДеревоСЭлементамиФормы(НоваяСтрока, ТекЭлемент.ПодчиненныеЭлементы, СтруктураПутейКРеквизитам);
		ИначеЕсли ТипЗначениеЭлемента = Тип("ТаблицаФормы") Тогда
		    ПутьКДанным = ТекЭлемент.ПутьКДанным;
			СформироватьДеревоСЭлементамиФормы(НоваяСтрока,ТекЭлемент.ПодчиненныеЭлементы, СтруктураПутейКРеквизитам);
		ИначеЕсли ТипЗначениеЭлемента = Тип("ПолеФормы")  Тогда
		    ПутьКДанным = ТекЭлемент.ПутьКДанным;
		ИначеЕсли ТипЗначениеЭлемента = Тип("ДекорацияФормы") Тогда
			//Никаких дополнительных действий
		ИначеЕсли ТипЗначениеЭлемента = Тип("КнопкаФормы") Тогда
		Иначе	
			Сообщить("СформироватьДеревоСЭлементамиФормы:"+Строка(Тип(ТекЭлемент))+":"+ТекЭлемент.Имя)
		КонецЕсли; 
		
		Если ЗначениеЗаполнено(ПутьКДанным) Тогда
			// Найти последнюю точку
			Для НомерПозиции = 1 По СтрДлина(ПутьКДанным) Цикл
				Если Сред(ПутьКДанным,НомерПозиции,1)="." Тогда
					ПутьБезТочек = СтрЗаменить(Лев(ПутьКДанным,НомерПозиции-1),".","");
					СтруктураПутейКРеквизитам.Вставить(ПутьБезТочек);
				КонецЕсли; 
			КонецЦикла; 
		КонецЕсли; 
		
	КонецЦикла; 
		
КонецПроцедуры

Процедура СформироватьДеревоСРеквизитамиФормы(ДеревоРеквизитов, ТекущийПуть, Форма, ТекущийОбъект, СтруктураПутейКРеквизитам) Экспорт
	
	КоллекцияРеквизитов = Форма.ПолучитьРеквизиты(ТекущийПуть);
	
	Для каждого ТекРеквизит Из КоллекцияРеквизитов Цикл
		
		НоваяСтрока = ДеревоРеквизитов.Строки.Добавить();
		НоваяСтрока.Имя = ТекРеквизит.Имя;
		НоваяСтрока.Тип = Строка(ТекРеквизит.ТипЗначения);
		
		ТипРеквизита = СтроковоеПредставлениеОписанияТипа(ТекРеквизит.ТипЗначения);
		
		ШаблонНовыйРеквизит = "НовыйРеквизит = Новый РеквизитФормы(""%1"", %2, %3, %4, %5);";


		Путь = ?(ЗначениеЗаполнено(ТекРеквизит.Путь), """"+ТекРеквизит.Путь+"""", "");
		Заголовок = """"+ТекРеквизит.Заголовок+"""";
		СохраняемыеДанные = ТекстовоеПредставлениеЗначения(ТекРеквизит.СохраняемыеДанные);

		ТекстСоздания = СтрШаблон(ШаблонНовыйРеквизит, ТекРеквизит.Имя, ТипРеквизита, Путь, Заголовок, СохраняемыеДанные);
		
		НоваяСтрока.ТекстСоздания = ТекстСоздания; 
		
		Если (ТипЗнч(ТекущийОбъект)=Тип("ДанныеФормыСтруктура") ИЛИ ТипЗнч(ТекущийОбъект)=Тип("УправляемаяФорма"))
		   И СтруктураПутейКРеквизитам.Свойство(СтрЗаменить(ТекРеквизит.Путь+ТекРеквизит.Имя,".",""))
		    Тогда
			СформироватьДеревоСРеквизитамиФормы(НоваяСтрока,?(ЗначениеЗаполнено(ТекущийПуть),ТекущийПуть+".","")+ТекРеквизит.Имя,Форма,ТекущийОбъект[ТекРеквизит.Имя], СтруктураПутейКРеквизитам);
		КонецЕсли; 
		
	КонецЦикла; 
	
КонецПроцедуры

Процедура СформироватьКодПоСтрокам(ДеревоЭлементов,ПараметрыФорм)
	
	ФормаОбразец = ПараметрыФорм.ФормаОбразец;
	
	КоличествоСтрок = ДеревоЭлементов.Строки.Количество();
	СледующийЭлемент = "Неопределено";
	Для Индекс = 1 По КоличествоСтрок Цикл
		
		СтрокаЭлемента = ДеревоЭлементов.Строки[КоличествоСтрок-Индекс];
		ИмяЭлемента = СтрокаЭлемента.Имя;
		//Если ИмяЭлемента = "КоманднаяПанель" И СтрокаЭлемента.Родитель = Неопределено Тогда
		//	ТекЭлемент = ФормаОбразец.КоманднаяПанель;
		//Иначе
			ТекЭлемент = ФормаОбразец.Элементы[ИмяЭлемента];
		//КонецЕсли; 
		ТипЭлемента = "Тип("""+ПолучитьСтроковоеПредставлениеТипа(ТипЗнч(ТекЭлемент))+""")";
		Родитель    = ?(СтрокаЭлемента.Родитель <> Неопределено,"ЭтаФорма.Элементы."+СтрокаЭлемента.Родитель.Имя,"Неопределено");
			
		ТекстСозданияЭлемента =  
		"// ******   "+ТипЗнч(ТекЭлемент)+" """+ТекЭлемент.Имя+"""    ***********"+Символы.ПС+Символы.ПС+
		"НовыйЭлемент = Этаформа.Элементы.Вставить("""+ИмяЭлемента+""","+ТипЭлемента+","+Родитель+","+СледующийЭлемент+");";
		
		ЗаполнитьСвойстваЭлемента(ПараметрыФорм,ТекЭлемент);
		СтрокаЭлемента.ТекстСоздания = ТекстСозданияЭлемента;
			
		СледующийЭлемент = "ЭтаФорма.Элементы."+СтрокаЭлемента.Имя;
		СформироватьКодПоСтрокам(СтрокаЭлемента,ПараметрыФорм);
	КонецЦикла; 
	
КонецПроцедуры

Процедура ЗаполнитьСвойстваЭлемента(ПараметрыФорм,ТекЭлемент);
	
	СтруктураДанныхЭлемента = ПолучитьСвойстваЭлемента(ТекЭлемент);
	
	УстановитьОтличающиесяСвойства(СтруктураДанныхЭлемента,ТекЭлемент,ПараметрыФорм);
	
КонецПроцедуры // ЗаполнитьСвойстваЭлемента(ФормаОбразец,ИмяЭлемента);()

Функция ПолучитьСвойстваЭлемента(ЭлементОбразец)

	СтруктураКопируемыхСвойств = Новый Структура;
	СтруктураОбработчиков = Новый Структура;
	
	// СтруктураКопируемыхСвойств.Вставить("",);
	
	Если Тип(ЭлементОбразец) = Тип("ГруппаФормы") Тогда
		
		СтруктураКопируемыхСвойств.Вставить("Вид");
		СтруктураКопируемыхСвойств.Вставить("Видимость",Истина);
		СтруктураКопируемыхСвойств.Вставить("Высота",0);
		СтруктураКопируемыхСвойств.Вставить("Доступность",Истина);
		СтруктураКопируемыхСвойств.Вставить("Заголовок","");
		СтруктураКопируемыхСвойств.Вставить("ОтображениеПодсказки",ОтображениеПодсказки.Авто);
		СтруктураКопируемыхСвойств.Вставить("Подсказка","");
		СтруктураКопируемыхСвойств.Вставить("РазрешитьИзменениеСостава",Истина);
		СтруктураКопируемыхСвойств.Вставить("РастягиватьПоВертикали");
		СтруктураКопируемыхСвойств.Вставить("РастягиватьПоГоризонтали");
		СтруктураКопируемыхСвойств.Вставить("ТолькоПросмотр",Ложь);
		СтруктураКопируемыхСвойств.Вставить("ЦветТекстаЗаголовка",Новый Цвет());
		СтруктураКопируемыхСвойств.Вставить("Ширина",0);
		СтруктураКопируемыхСвойств.Вставить("ШрифтЗаголовка",Новый Шрифт());
		
		Если ЭлементОбразец.Вид = ВидГруппыФормы.ОбычнаяГруппа Тогда
			СтруктураКопируемыхСвойств.Вставить("Группировка",ГруппировкаПодчиненныхЭлементовФормы.Вертикальная);
			СтруктураКопируемыхСвойств.Вставить("ОтображатьЗаголовок",Истина);
			СтруктураКопируемыхСвойств.Вставить("Отображение",ОтображениеОбычнойГруппы.ОбычноеВыделение);
			СтруктураКопируемыхСвойств.Вставить("Поведение",ПоведениеОбычнойГруппы.Обычное);
			СтруктураКопируемыхСвойств.Вставить("ПутьКДаннымЗаголовка","");  //Определяется в "ДанныеЭлементов"
		Иначе
			//Другие виды
		КонецЕсли; 
		
	ИначеЕсли Тип(ЭлементОбразец) = Тип("ТаблицаФормы") Тогда
		
		СтруктураКопируемыхСвойств.Вставить("ПутьКДанным","");	//Определяется в "ДанныеЭлементов"	 
		СтруктураКопируемыхСвойств.Вставить("АвтоВводНезаполненного",Неопределено);
		СтруктураКопируемыхСвойств.Вставить("АвтоВводНовойСтроки",Неопределено);
		СтруктураКопируемыхСвойств.Вставить("АктивизироватьПоУмолчанию",Ложь);
		СтруктураКопируемыхСвойств.Вставить("ВертикальнаяПолосаПрокрутки",ИспользованиеПолосыПрокрутки.ИспользоватьАвтоматически);
		СтруктураКопируемыхСвойств.Вставить("ВертикальныеЛинии",Истина);
		СтруктураКопируемыхСвойств.Вставить("Видимость",Истина);
		СтруктураКопируемыхСвойств.Вставить("Вывод",ИспользованиеВывода.Авто);
		СтруктураКопируемыхСвойств.Вставить("Высота",0);
		СтруктураКопируемыхСвойств.Вставить("ВысотаВСтрокахТаблицы",0);
		СтруктураКопируемыхСвойств.Вставить("ВысотаЗаголовка",0);
		СтруктураКопируемыхСвойств.Вставить("ВысотаПодвала",1);
		СтруктураКопируемыхСвойств.Вставить("ВысотаШапки",1);
		СтруктураКопируемыхСвойств.Вставить("ГоризонтальнаяПолосаПрокрутки",ИспользованиеПолосыПрокрутки.ИспользоватьАвтоматически);
		СтруктураКопируемыхСвойств.Вставить("ГоризонтальныеЛинии",Истина);
		СтруктураКопируемыхСвойств.Вставить("Доступность",Истина);
		СтруктураКопируемыхСвойств.Вставить("Заголовок","");
		СтруктураКопируемыхСвойств.Вставить("ИзменятьПорядокСтрок",Истина);
		СтруктураКопируемыхСвойств.Вставить("ИзменятьСоставСтрок",Истина);
		СтруктураКопируемыхСвойств.Вставить("МножественныйВыбор",Ложь);
		СтруктураКопируемыхСвойств.Вставить("НачальноеОтображениеДерева",НачальноеОтображениеДерева.НеРаскрывать);
		СтруктураКопируемыхСвойств.Вставить("НачальноеОтображениеСписка",НачальноеОтображениеСписка.Авто);
		СтруктураКопируемыхСвойств.Вставить("Отображение",ОтображениеТаблицы.Список);
		СтруктураКопируемыхСвойств.Вставить("ОтображениеПодсказки",ОтображениеПодсказки.Авто);
		СтруктураКопируемыхСвойств.Вставить("Подвал",Ложь);
		СтруктураКопируемыхСвойств.Вставить("Подсказка","");
		СтруктураКопируемыхСвойств.Вставить("ПоложениеЗаголовка",ПоложениеЗаголовкаЭлементаФормы.Авто);
		СтруктураКопируемыхСвойств.Вставить("ПоложениеКоманднойПанели",ПоложениеКоманднойПанелиЭлементаФормы.Авто);
		СтруктураКопируемыхСвойств.Вставить("ПоложениеСостоянияПросмотра",ПоложениеСостоянияПросмотра.Авто);
		СтруктураКопируемыхСвойств.Вставить("РастягиватьПоВертикали",Истина);
		СтруктураКопируемыхСвойств.Вставить("РастягиватьПоГоризонтали",Истина);
		СтруктураКопируемыхСвойств.Вставить("РежимВводаСтрок",РежимВводаСтрокТаблицы.ВКонецСписка);
		СтруктураКопируемыхСвойств.Вставить("РежимВыбора",Ложь);
		СтруктураКопируемыхСвойств.Вставить("РежимВыделения",РежимВыделенияТаблицы.Одиночный);
		СтруктураКопируемыхСвойств.Вставить("РежимВыделенияСтроки",РежимВыделенияСтрокиТаблицы.Ячейка);
		СтруктураКопируемыхСвойств.Вставить("ЦветРамки",Новый Цвет());
		СтруктураКопируемыхСвойств.Вставить("ЦветТекста",Новый Цвет());
		СтруктураКопируемыхСвойств.Вставить("ЦветТекстаЗаголовка",Новый Цвет());
		СтруктураКопируемыхСвойств.Вставить("ЦветФона",Новый Цвет());
		СтруктураКопируемыхСвойств.Вставить("Шапка",Истина);
		СтруктураКопируемыхСвойств.Вставить("Шрифт",Новый Шрифт());
		СтруктураКопируемыхСвойств.Вставить("ШрифтЗаголовка",Новый Шрифт());
		//СтруктураКопируемыхСвойств.Вставить("",);
		
		СтруктураОбработчиков.Вставить("ПриИзменении");
		СтруктураОбработчиков.Вставить("Выбор");
		СтруктураОбработчиков.Вставить("ПриАктивацииСтроки");
		СтруктураОбработчиков.Вставить("ВыборЗначения");
		СтруктураОбработчиков.Вставить("ПриАктивизацииПоля");
		СтруктураОбработчиков.Вставить("ПриАктивизацииЯчейки");
		СтруктураОбработчиков.Вставить("ПередНачаломДобавления");
		СтруктураОбработчиков.Вставить("ПередНачаломИзменении");
		СтруктураОбработчиков.Вставить("ПередУдалением");
		СтруктураОбработчиков.Вставить("ПриНачалеРедактирования");
		СтруктураОбработчиков.Вставить("ПередОкончаниемРедактирования");
		СтруктураОбработчиков.Вставить("ПриОкончанииРедактирования");
		СтруктураОбработчиков.Вставить("ОбработкаВыбора");
		СтруктураОбработчиков.Вставить("ПередРазворачиванием");
		СтруктураОбработчиков.Вставить("ПередСворачиванием");
		СтруктураОбработчиков.Вставить("ПослеУдаления");
		СтруктураОбработчиков.Вставить("ПриСменеТекущегоРодителя");
		СтруктураОбработчиков.Вставить("ОбработкаЗаписиНового");
		СтруктураОбработчиков.Вставить("НачалоПеретаскивания");
		СтруктураОбработчиков.Вставить("ПроверкаПеретаскивания");
		СтруктураОбработчиков.Вставить("ОкончаниеПеретаскивания");
		СтруктураОбработчиков.Вставить("Перетаскивание");
		
	ИначеЕсли Тип(ЭлементОбразец) = Тип("ПолеФормы") Тогда
		
		СтруктураКопируемыхСвойств.Вставить("Вид");
		СтруктураКопируемыхСвойств.Вставить("ВертикальноеПоложение",ВертикальноеПоложениеЭлемента.Авто);
		СтруктураКопируемыхСвойств.Вставить("ГоризонтальноеПоложение",ГоризонтальноеПоложениеЭлемента.Авто);
		СтруктураКопируемыхСвойств.Вставить("Заголовок","");
		СтруктураКопируемыхСвойств.Вставить("Подсказка","");
		СтруктураКопируемыхСвойств.Вставить("ПоложениеЗаголовка",ПоложениеЗаголовкаЭлементаФормы.Авто);
		СтруктураКопируемыхСвойств.Вставить("ПутьКДанным","");       //Определяется в "ДанныеЭлементов"
		СтруктураКопируемыхСвойств.Вставить("ПутьКДаннымПодвала","");    //Определяется в "ДанныеЭлементов"
		СтруктураКопируемыхСвойств.Вставить("ЦветТекстаЗаголовка",Новый Цвет());
		СтруктураКопируемыхСвойств.Вставить("ЦветТекстаПодвала",Новый Цвет());
		СтруктураКопируемыхСвойств.Вставить("ЦветФонаЗаголовка",Новый Цвет());
		СтруктураКопируемыхСвойств.Вставить("ЦветФонаПодвала",Новый Цвет());
		СтруктураКопируемыхСвойств.Вставить("ШрифтЗаголовка",Новый Шрифт());
		СтруктураКопируемыхСвойств.Вставить("ШрифтПодвала",Новый Шрифт());
		
		СтруктураОбработчиков.Вставить("ПриИзменении");
		СтруктураОбработчиков.Вставить("НачалоВыбора");
		СтруктураОбработчиков.Вставить("НачалоВыбораИзСписка");
		СтруктураОбработчиков.Вставить("Очистка");
		СтруктураОбработчиков.Вставить("Регулирование");
		СтруктураОбработчиков.Вставить("Открытие");
		СтруктураОбработчиков.Вставить("Создание");
		СтруктураОбработчиков.Вставить("ОбработкаВыбора");
		СтруктураОбработчиков.Вставить("ИзменениеТекстаРедактирования");
		СтруктураОбработчиков.Вставить("АвтоПодбор");
		СтруктураОбработчиков.Вставить("ОкончаниеВводаТекста");
		
		
		Если ЭлементОбразец.Вид = ВидПоляФормы.ПолеВвода Тогда
			СтруктураКопируемыхСвойств.Вставить("КнопкаВыбора",Неопределено);
			СтруктураКопируемыхСвойств.Вставить("КнопкаВыпадающегоСписка",Неопределено);
			СтруктураКопируемыхСвойств.Вставить("КнопкаОткрытия",Неопределено);
			СтруктураКопируемыхСвойств.Вставить("КнопкаОчистки",Неопределено);
			СтруктураКопируемыхСвойств.Вставить("КнопкаРегулирования",Неопределено);
			СтруктураКопируемыхСвойств.Вставить("КнопкаСоздания",Неопределено);
		Иначе
			//Другие виды
		КонецЕсли; 
		
		
		//СтруктураКопируемыхСвойств.Вставить("ПутьКДаннымПодвала","");
		
	ИначеЕсли Тип(ЭлементОбразец) = Тип("ДекорацияФормы") Тогда	
		
		СтруктураКопируемыхСвойств.Вставить("Вид");
		СтруктураКопируемыхСвойств.Вставить("Видимость",Истина);
		СтруктураКопируемыхСвойств.Вставить("Высота",0);
		СтруктураКопируемыхСвойств.Вставить("Доступность",Истина);
		СтруктураКопируемыхСвойств.Вставить("Заголовок","");
		СтруктураКопируемыхСвойств.Вставить("ОтображениеПодсказки",ОтображениеПодсказки.Авто);
		СтруктураКопируемыхСвойств.Вставить("Подсказка","");
		СтруктураКопируемыхСвойств.Вставить("ПропускатьПриВводе",Неопределено);
		СтруктураКопируемыхСвойств.Вставить("РастягиватьПоВертикали",Неопределено);
		СтруктураКопируемыхСвойств.Вставить("РастягиватьПоГоризонтали",Неопределено);
		СтруктураКопируемыхСвойств.Вставить("ЦветТекста",Новый Цвет());
		СтруктураКопируемыхСвойств.Вставить("Ширина",0);
		СтруктураКопируемыхСвойств.Вставить("Шрифт",Новый Шрифт());
		
		СтруктураОбработчиков.Вставить("Нажатие");
		СтруктураОбработчиков.Вставить("ОбработкаНавигационнойСсылки");
		
	ИначеЕсли Тип(ЭлементОбразец) = Тип("КнопкаФормы") Тогда	
		
		СтруктураКопируемыхСвойств.Вставить("Вид",ВидКнопкиФормы.ОбычнаяКнопка);
		СтруктураКопируемыхСвойств.Вставить("АктивизироватьПоУмолчанию",Ложь);
		СтруктураКопируемыхСвойств.Вставить("Видимость",Истина);
		СтруктураКопируемыхСвойств.Вставить("Высота",0);
		СтруктураКопируемыхСвойств.Вставить("ВысотаЗаголовка",0);
		СтруктураКопируемыхСвойств.Вставить("Доступность",Истина);
		СтруктураКопируемыхСвойств.Вставить("Заголовок","");
		СтруктураКопируемыхСвойств.Вставить("ИмяКоманды","");
		СтруктураКопируемыхСвойств.Вставить("КнопкаПоУмолчанию",Ложь);
		СтруктураКопируемыхСвойств.Вставить("Отображение",ОтображениеКнопки.Авто);
		СтруктураКопируемыхСвойств.Вставить("ОтображениеПодсказки",ОтображениеПодсказки.Авто);
		СтруктураКопируемыхСвойств.Вставить("Пометка",Ложь);
		СтруктураКопируемыхСвойств.Вставить("ПропускатьПриВводе",Неопределено);
		СтруктураКопируемыхСвойств.Вставить("ТолькоВоВсехДействиях",Неопределено);
		СтруктураКопируемыхСвойств.Вставить("ЦветРамки",Новый Цвет());
		СтруктураКопируемыхСвойств.Вставить("ЦветТекста",Новый Цвет());
		СтруктураКопируемыхСвойств.Вставить("ЦветФона",Новый Цвет());
		СтруктураКопируемыхСвойств.Вставить("Ширина",0);
		СтруктураКопируемыхСвойств.Вставить("Шрифт",Новый Шрифт());
		
	Иначе
		
		Сообщить("Не определен тип элемента:"+Тип(ЭлементОбразец));
		
	КонецЕсли; 
	
	СтруктураДанныхЭлемента = Новый Структура("СтруктураКопируемыхСвойств,СтруктураОбработчиков",СтруктураКопируемыхСвойств,СтруктураОбработчиков);
	
	Возврат СтруктураДанныхЭлемента;

КонецФункции // ПолучитьСвойстваЭлемента()
 
Процедура УстановитьОтличающиесяСвойства(СтруктураДанныхЭлемента,ТекЭлемент,ПараметрыФорм)
	
	//Свойства и обработчики, которые нужно проверить и установить
	СтруктураКопируемыхСвойств = СтруктураДанныхЭлемента.СтруктураКопируемыхСвойств;
	СтруктураОбработчиков = СтруктураДанныхЭлемента.СтруктураОбработчиков;
	
	//Установить свойства
	Для каждого Свойство Из СтруктураКопируемыхСвойств Цикл
		Если ТекЭлемент[Свойство.Ключ] <> Свойство.Значение Тогда
			ДобавитьКопированиеСвойства(Свойство.Ключ,ТекЭлемент,ПараметрыФорм);
		КонецЕсли; 	
	КонецЦикла; 
	
	//Установить действия
	Для каждого Свойство Из СтруктураОбработчиков Цикл
		ОбработчикИмя = ТекЭлемент.ПолучитьДействие(Свойство.Ключ); 
		Если НЕ ПустаяСтрока(ОбработчикИмя) Тогда
			ТекстСозданияЭлемента = ТекстСозданияЭлемента + Символы.ПС+
			"НовыйЭлемент.УстановитьДействие("""+Свойство.Ключ+""","""+ОбработчикИмя+""");";
		КонецЕсли; 
	КонецЦикла; 
	
КонецПроцедуры // УстановитьОтличающеесяСвойство()

Процедура ДобавитьКопированиеСвойства(ИмяСвойства,ТекЭлемент,ПараметрыФорм)
	
	Значение = ТекЭлемент[ИмяСвойства];
	
	ПредставлениеЗначения = ПолучитьТекстовоеПредставлениеЗначения(Значение);
	
	ТекстСозданияЭлемента = СокрЛП(ТекстСозданияЭлемента) + Символы.ПС+
	"НовыйЭлемент."+ИмяСвойства+" = "+ПредставлениеЗначения+";";
	
КонецПроцедуры // ДобавитьТекст()

Функция ПолучитьТекстовоеПредставлениеЗначения(Значение)
	
	СоответствиеТекстовыхПредставлений = НовоеСоответствиеТекстовыхПредставлений();
	
	//Для текстовых значений добавляем кавычки в вывод
	//для нетекстовых получаем текстовое представление значения свойства
	ПредставлениеЗначения = Неопределено;
	Если Значение = Неопределено Тогда
		ПредставлениеЗначения = "Неопределено";
	ИначеЕсли ТипЗнч(Значение) = Тип("Строка") Тогда
		ПредставлениеЗначения = """"+Значение+"""";
	ИначеЕсли ТипЗнч(Значение) = Тип("Число") Тогда
		ПредставлениеЗначения = Формат(Значение,"ЧН=; ЧГ=0");
	ИначеЕсли ТипЗнч(Значение) = Тип("Шрифт")
		ИЛИ ТипЗнч(Значение) = Тип("Цвет") Тогда
		ПредставлениеЗначения = ПолучитьТекстовоеПредставлениеСложногоТипа(Значение)
	Иначе	
		ПредставлениеЗначения = СоответствиеТекстовыхПредставлений.Получить(Значение);
	КонецЕсли; 
	
	Возврат ПредставлениеЗначения;
	
КонецФункции // ПолучитьТекстовоеПредставлениеЗначения()

#Область СлужебныеПроцедурыИФункции

Процедура ПоместитьПустыеДанныеВХранилище() Экспорт
	
	СохраненноеДеревоЭлементов = ЭтотОбъект.ДеревоЭлементов.Скопировать();
	СохраненноеДеревоЭлементов.Строки.Очистить();
	СохраненноеДеревоРеквизитов = ЭтотОбъект.ДеревоРеквизитов.Скопировать();
	СохраненноеДеревоРеквизитов.Строки.Очистить();
	СохраненнаяТаблицаКоманд = ЭтотОбъект.ТаблицаКоманд.ВыгрузитьКолонки();
	
	СоответствиеТекстовыхПредставлений = НовоеСоответствиеТекстовыхПредставлений();
	СоответствиеПредставленийТипов = НовоеСоответствиеПредставленийТипов();
	
	ПараметрыДекомпиляции = Новый Структура;
	ПараметрыДекомпиляции.Вставить("СоответствиеТекстовыхПредставлений", СоответствиеТекстовыхПредставлений);
	ПараметрыДекомпиляции.Вставить("СоответствиеПредставленийТипов", СоответствиеПредставленийТипов);
	ПараметрыДекомпиляции.Вставить("ДеревоРеквизитов", СохраненноеДеревоРеквизитов);	
	ПараметрыДекомпиляции.Вставить("ДеревоЭлементов", СохраненноеДеревоЭлементов);
	ПараметрыДекомпиляции.Вставить("ТаблицаКоманд", СохраненнаяТаблицаКоманд);
	
	ЭтотОбъект.АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(ПараметрыДекомпиляции,ЭтотОбъект.АдресВоВременномХранилище);
	ЭтотОбъект.ИмяПодключеннойОбработки = ЭтотОбъект.ИспользуемоеИмяФайла;
	ЭтотОбъект.ИмяВременногоФайла = ПолучитьИмяВременногоФайла(); 
	
КонецПроцедуры

Функция НовоеСоответствиеТекстовыхПредставлений() Экспорт
	
	СоответствиеТекстовыхПредставлений = Новый Соответствие;
		
	СоответствиеТекстовыхПредставлений.Вставить(Истина, "Истина");
	СоответствиеТекстовыхПредставлений.Вставить(Ложь, "Ложь");
	
	//ВертикальноеПоложениеЭлемента
	СоответствиеТекстовыхПредставлений.Вставить(ВертикальноеПоложениеЭлемента.Авто,"ВертикальноеПоложениеЭлемента.Авто");
	СоответствиеТекстовыхПредставлений.Вставить(ВертикальноеПоложениеЭлемента.Верх,"ВертикальноеПоложениеЭлемента.Верх");
	СоответствиеТекстовыхПредставлений.Вставить(ВертикальноеПоложениеЭлемента.Низ,"ВертикальноеПоложениеЭлемента.Низ");
	СоответствиеТекстовыхПредставлений.Вставить(ВертикальноеПоложениеЭлемента.Центр,"ВертикальноеПоложениеЭлемента.Центр");
	
	//ВидГруппаФормы
	СоответствиеТекстовыхПредставлений.Вставить(ВидГруппыФормы.ГруппаКнопок,"ВидГруппыФормы.ГруппаКнопок");
	СоответствиеТекстовыхПредставлений.Вставить(ВидГруппыФормы.ГруппаКолонок,"ВидГруппыФормы.ГруппаКолонок");
	СоответствиеТекстовыхПредставлений.Вставить(ВидГруппыФормы.КоманднаяПанель,"ВидГруппыФормы.КоманднаяПанель");
	СоответствиеТекстовыхПредставлений.Вставить(ВидГруппыФормы.КонтекстноеМеню,"ВидГруппыФормы.КонтекстноеМеню");
	СоответствиеТекстовыхПредставлений.Вставить(ВидГруппыФормы.ОбычнаяГруппа,"ВидГруппыФормы.ОбычнаяГруппа");
	СоответствиеТекстовыхПредставлений.Вставить(ВидГруппыФормы.Подменю,"ВидГруппыФормы.Подменю");
	СоответствиеТекстовыхПредставлений.Вставить(ВидГруппыФормы.Страница,"ВидГруппыФормы.Страница");
	СоответствиеТекстовыхПредставлений.Вставить(ВидГруппыФормы.Страницы,"ВидГруппыФормы.Страницы");
	
	//ВидДекорацииФормы
	СоответствиеТекстовыхПредставлений.Вставить(ВидДекорацииФормы.Картинка,"ВидДекорацииФормы.Картинка");
	СоответствиеТекстовыхПредставлений.Вставить(ВидДекорацииФормы.Надпись,"ВидДекорацииФормы.Надпись");
	
	//ВидКнопкиФормы
	СоответствиеТекстовыхПредставлений.Вставить(ВидКнопкиФормы.Гиперссылка,"ВидКнопкиФормы.Гиперссылка");
	СоответствиеТекстовыхПредставлений.Вставить(ВидКнопкиФормы.КнопкаКоманднойПанели,"ВидКнопкиФормы.КнопкаКоманднойПанели");
	СоответствиеТекстовыхПредставлений.Вставить(ВидКнопкиФормы.ОбычнаяКнопка,"ВидКнопкиФормы.ОбычнаяКнопка");
	
	//ВидПоляФормы
	СоответствиеТекстовыхПредставлений.Вставить(ВидПоляФормы.ПолеHTMLДокумента,"ВидПоляФормы.ПолеHTMLДокумента");
	СоответствиеТекстовыхПредставлений.Вставить(ВидПоляФормы.ПолеВвода,"ВидПоляФормы.ПолеВвода");
	СоответствиеТекстовыхПредставлений.Вставить(ВидПоляФормы.ПолеГеографическойСхемы,"ВидПоляФормы.ПолеГеографическойСхемы");
	СоответствиеТекстовыхПредставлений.Вставить(ВидПоляФормы.ПолеГрафическойСхемы,"ВидПоляФормы.ПолеГрафическойСхемы");
	СоответствиеТекстовыхПредставлений.Вставить(ВидПоляФормы.ПолеДендрограммы,"ВидПоляФормы.ПолеДендрограммы");
	СоответствиеТекстовыхПредставлений.Вставить(ВидПоляФормы.ПолеДиаграммы,"ВидПоляФормы.ПолеДиаграммы");
	СоответствиеТекстовыхПредставлений.Вставить(ВидПоляФормы.ПолеДиаграммыГанта,"ВидПоляФормы.ПолеДиаграммыГанта");
	СоответствиеТекстовыхПредставлений.Вставить(ВидПоляФормы.ПолеКалендаря,"ВидПоляФормы.ПолеКалендаря");
	СоответствиеТекстовыхПредставлений.Вставить(ВидПоляФормы.ПолеИндикатора,"ВидПоляФормы.ПолеИндикатора");
	СоответствиеТекстовыхПредставлений.Вставить(ВидПоляФормы.ПолеКартинки,"ВидПоляФормы.ПолеКартинки");
	СоответствиеТекстовыхПредставлений.Вставить(ВидПоляФормы.ПолеНадписи,"ВидПоляФормы.ПолеНадписи");
	СоответствиеТекстовыхПредставлений.Вставить(ВидПоляФормы.ПолеПереключателя,"ВидПоляФормы.ПолеПереключателя");
	СоответствиеТекстовыхПредставлений.Вставить(ВидПоляФормы.ПолеПериода,"ВидПоляФормы.ПолеПериода");
	СоответствиеТекстовыхПредставлений.Вставить(ВидПоляФормы.ПолеПолосыРегулирования,"ВидПоляФормы.ПолеПолосыРегулирования");
	СоответствиеТекстовыхПредставлений.Вставить(ВидПоляФормы.ПолеТабличногоДокумента,"ВидПоляФормы.ПолеТабличногоДокумента");
	СоответствиеТекстовыхПредставлений.Вставить(ВидПоляФормы.ПолеТекстовогоДокумента,"ВидПоляФормы.ПолеТекстовогоДокумента");
	СоответствиеТекстовыхПредставлений.Вставить(ВидПоляФормы.ПолеФлажка,"ВидПоляФормы.ПолеФлажка");
	СоответствиеТекстовыхПредставлений.Вставить(ВидПоляФормы.ПолеФорматированногоДокумента,"ВидПоляФормы.ПолеФорматированногоДокумента");
	
	//ГоризонтальноеПоложениеЭлемента
	СоответствиеТекстовыхПредставлений.Вставить(ГоризонтальноеПоложениеЭлемента.Авто,"ГоризонтальноеПоложениеЭлемента.Авто");
	СоответствиеТекстовыхПредставлений.Вставить(ГоризонтальноеПоложениеЭлемента.Лево,"ГоризонтальноеПоложениеЭлемента.Лево");
	СоответствиеТекстовыхПредставлений.Вставить(ГоризонтальноеПоложениеЭлемента.Право,"ГоризонтальноеПоложениеЭлемента.Право");
	СоответствиеТекстовыхПредставлений.Вставить(ГоризонтальноеПоложениеЭлемента.Центр,"ГоризонтальноеПоложениеЭлемента.Центр");
	
	//ГруппировкаПодчиненныхЭлементовФормы
	СоответствиеТекстовыхПредставлений.Вставить(ГруппировкаПодчиненныхЭлементовФормы.Вертикальная,"ГруппировкаПодчиненныхЭлементовФормы.Вертикальная");
	СоответствиеТекстовыхПредставлений.Вставить(ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная,"ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная");
	
	//ИспользованиеВывода
	СоответствиеТекстовыхПредставлений.Вставить(ИспользованиеВывода.Авто,"ИспользованиеВывода.Авто");
	СоответствиеТекстовыхПредставлений.Вставить(ИспользованиеВывода.Запретить,"ИспользованиеВывода.Запретить");
	СоответствиеТекстовыхПредставлений.Вставить(ИспользованиеВывода.Разрешить,"ИспользованиеВывода.Разрешить");
	
	//ИспользованиеПолосыПрокрутки
	СоответствиеТекстовыхПредставлений.Вставить(ИспользованиеПолосыПрокрутки.ИспользоватьАвтоматически,"ИспользованиеПолосыПрокрутки.ИспользоватьАвтоматически");
	СоответствиеТекстовыхПредставлений.Вставить(ИспользованиеПолосыПрокрутки.ИспользоватьВсегда,"ИспользованиеПолосыПрокрутки.ИспользоватьВсегда");
	СоответствиеТекстовыхПредставлений.Вставить(ИспользованиеПолосыПрокрутки.НеИспользовать,"ИспользованиеПолосыПрокрутки.НеИспользовать");
	
	//НачальноеОтображениеДерева
	СоответствиеТекстовыхПредставлений.Вставить(НачальноеОтображениеДерева.НеРаскрывать,"НачальноеОтображениеДерева.НеРаскрывать");
	СоответствиеТекстовыхПредставлений.Вставить(НачальноеОтображениеДерева.РаскрыватьВерхнийУровень,"НачальноеОтображениеДерева.РаскрыватьВерхнийУровень");
	СоответствиеТекстовыхПредставлений.Вставить(НачальноеОтображениеДерева.РаскрыватьВсеУровни,"НачальноеОтображениеДерева.РаскрыватьВсеУровни");
	
	//НачальноеОтображениеСписка
	СоответствиеТекстовыхПредставлений.Вставить(НачальноеОтображениеСписка.Авто,"НачальноеОтображениеСписка.Авто");
	СоответствиеТекстовыхПредставлений.Вставить(НачальноеОтображениеСписка.Конец,"НачальноеОтображениеСписка.Конец");
	СоответствиеТекстовыхПредставлений.Вставить(НачальноеОтображениеСписка.Начало,"НачальноеОтображениеСписка.Начало");
	
	//ОтображениеКнопки
	СоответствиеТекстовыхПредставлений.Вставить(ОтображениеКнопки.Авто,"ОтображениеКнопки.Авто");
	СоответствиеТекстовыхПредставлений.Вставить(ОтображениеКнопки.Картинка,"ОтображениеКнопки.Картинка");
	СоответствиеТекстовыхПредставлений.Вставить(ОтображениеКнопки.КартинкаИТекст,"ОтображениеКнопки.КартинкаИТекст");
	СоответствиеТекстовыхПредставлений.Вставить(ОтображениеКнопки.Текст,"ОтображениеКнопки.Текст");
	
	//ОтображениеОбычнойГруппы
	СоответствиеТекстовыхПредставлений.Вставить(ОтображениеОбычнойГруппы.Нет,"ОтображениеОбычнойГруппы.Нет");
	СоответствиеТекстовыхПредставлений.Вставить(ОтображениеОбычнойГруппы.ОбычноеВыделение,"ОтображениеОбычнойГруппы.ОбычноеВыделение");
	СоответствиеТекстовыхПредставлений.Вставить(ОтображениеОбычнойГруппы.СильноеВыделение,"ОтображениеОбычнойГруппы.СильноеВыделение");
	СоответствиеТекстовыхПредставлений.Вставить(ОтображениеОбычнойГруппы.СлабоеВыделение,"ОтображениеОбычнойГруппы.СлабоеВыделение");
	
	//ОтображениеПодсказки
	СоответствиеТекстовыхПредставлений.Вставить(ОтображениеПодсказки.Авто,"ОтображениеПодсказки.Авто");
	СоответствиеТекстовыхПредставлений.Вставить(ОтображениеПодсказки.Всплывающая,"ОтображениеПодсказки.Всплывающая");
	СоответствиеТекстовыхПредставлений.Вставить(ОтображениеПодсказки.Кнопка,"ОтображениеПодсказки.Кнопка");
	СоответствиеТекстовыхПредставлений.Вставить(ОтображениеПодсказки.Нет,"ОтображениеПодсказки.Нет");
	СоответствиеТекстовыхПредставлений.Вставить(ОтображениеПодсказки.ОтображатьАвто,"ОтображениеПодсказки.ОтображатьАвто");
	СоответствиеТекстовыхПредставлений.Вставить(ОтображениеПодсказки.ОтображатьСверху,"ОтображениеПодсказки.ОтображатьСверху");
	СоответствиеТекстовыхПредставлений.Вставить(ОтображениеПодсказки.ОтображатьСлева,"ОтображениеПодсказки.ОтображатьСлева");
	СоответствиеТекстовыхПредставлений.Вставить(ОтображениеПодсказки.ОтображатьСнизу,"ОтображениеПодсказки.ОтображатьСнизу");
	СоответствиеТекстовыхПредставлений.Вставить(ОтображениеПодсказки.ОтображатьСправа,"ОтображениеПодсказки.ОтображатьСправа");
	
	//ОтображениеТаблицы
	СоответствиеТекстовыхПредставлений.Вставить(ОтображениеТаблицы.Дерево,"ОтображениеТаблицы.Дерево");
	СоответствиеТекстовыхПредставлений.Вставить(ОтображениеТаблицы.ИерархическийСписок,"ОтображениеТаблицы.ИерархическийСписок");
	СоответствиеТекстовыхПредставлений.Вставить(ОтображениеТаблицы.Список,"ОтображениеТаблицы.Список");
	
	//ПоведениеОбычнойГруппы
	СоответствиеТекстовыхПредставлений.Вставить(ПоведениеОбычнойГруппы.Обычное,"ПоведениеОбычнойГруппы.Обычное");
	СоответствиеТекстовыхПредставлений.Вставить(ПоведениеОбычнойГруппы.Свертываемая,"ПоведениеОбычнойГруппы.Свертываемая");
	
	//ПоложениеЗаголовкаЭлементаФормы
	СоответствиеТекстовыхПредставлений.Вставить(ПоложениеЗаголовкаЭлементаФормы.Авто,"ПоложениеЗаголовкаЭлементаФормы.Авто");
	СоответствиеТекстовыхПредставлений.Вставить(ПоложениеЗаголовкаЭлементаФормы.Верх,"ПоложениеЗаголовкаЭлементаФормы.Верх");
	СоответствиеТекстовыхПредставлений.Вставить(ПоложениеЗаголовкаЭлементаФормы.Лево,"ПоложениеЗаголовкаЭлементаФормы.Лево");
	СоответствиеТекстовыхПредставлений.Вставить(ПоложениеЗаголовкаЭлементаФормы.Нет,"ПоложениеЗаголовкаЭлементаФормы.Нет");
	СоответствиеТекстовыхПредставлений.Вставить(ПоложениеЗаголовкаЭлементаФормы.Низ,"ПоложениеЗаголовкаЭлементаФормы.Низ");
	СоответствиеТекстовыхПредставлений.Вставить(ПоложениеЗаголовкаЭлементаФормы.Право,"ПоложениеЗаголовкаЭлементаФормы.Право");
	
	//ПоложениеКоманднойПанелиЭлементаФормы
	СоответствиеТекстовыхПредставлений.Вставить(ПоложениеКоманднойПанелиЭлементаФормы.Авто,"ПоложениеКоманднойПанелиЭлементаФормы.Авто");
	СоответствиеТекстовыхПредставлений.Вставить(ПоложениеКоманднойПанелиЭлементаФормы.Верх,"ПоложениеКоманднойПанелиЭлементаФормы.Верх");
	СоответствиеТекстовыхПредставлений.Вставить(ПоложениеКоманднойПанелиЭлементаФормы.Нет,"ПоложениеКоманднойПанелиЭлементаФормы.Нет");
	СоответствиеТекстовыхПредставлений.Вставить(ПоложениеКоманднойПанелиЭлементаФормы.Низ,"ПоложениеКоманднойПанелиЭлементаФормы.Низ");
	
	//ПоложениеСостоянияПросмотра	
	СоответствиеТекстовыхПредставлений.Вставить(ПоложениеСостоянияПросмотра.Авто,"ПоложениеСостоянияПросмотра.Авто");
	СоответствиеТекстовыхПредставлений.Вставить(ПоложениеСостоянияПросмотра.Верх,"ПоложениеСостоянияПросмотра.Верх");
	СоответствиеТекстовыхПредставлений.Вставить(ПоложениеСостоянияПросмотра.Нет,"ПоложениеСостоянияПросмотра.Нет");
	СоответствиеТекстовыхПредставлений.Вставить(ПоложениеСостоянияПросмотра.Низ,"ПоложениеСостоянияПросмотра.Низ");
	
	//РежимВводаСтрокТаблицы
	СоответствиеТекстовыхПредставлений.Вставить(РежимВводаСтрокТаблицы.ВКонецОкна,"РежимВводаСтрокТаблицы.ВКонецОкна");
	СоответствиеТекстовыхПредставлений.Вставить(РежимВводаСтрокТаблицы.ВКонецСписка,"РежимВводаСтрокТаблицы.ВКонецСписка");
	СоответствиеТекстовыхПредставлений.Вставить(РежимВводаСтрокТаблицы.ПередТекущейСтрокой,"РежимВводаСтрокТаблицы.ПередТекущейСтрокой");
	СоответствиеТекстовыхПредставлений.Вставить(РежимВводаСтрокТаблицы.ПослеТекущейСтроки,"РежимВводаСтрокТаблицы.ПослеТекущейСтроки");
	
	//РежимВыделенияТаблицы
	СоответствиеТекстовыхПредставлений.Вставить(РежимВыделенияТаблицы.Множественный,"РежимВыделенияТаблицы.Множественный");
	СоответствиеТекстовыхПредставлений.Вставить(РежимВыделенияТаблицы.Одиночный,"РежимВыделенияТаблицы.Одиночный");
	
	//РежимВыделенияСтрокиТаблицы
	СоответствиеТекстовыхПредставлений.Вставить(РежимВыделенияСтрокиТаблицы.Строка,"РежимВыделенияСтрокиТаблицы.Строка");
	СоответствиеТекстовыхПредставлений.Вставить(РежимВыделенияСтрокиТаблицы.Ячейка,"РежимВыделенияСтрокиТаблицы.Ячейка");
	
	Возврат СоответствиеТекстовыхПредставлений;
	
КонецФункции

Функция НовоеСоответствиеПредставленийТипов() Экспорт
	
	СоответствиеПредставленийТипов = Новый Соответствие;
	
	МассивДопустимыхТипов = ДопустимыеТипы();
	
	Для каждого ПредставлениеТипа Из МассивДопустимыхТипов Цикл
		СоответствиеПредставленийТипов.Вставить(Тип(ПредставлениеТипа),ПредставлениеТипа);
	КонецЦикла; 
	
	Возврат СоответствиеПредставленийТипов;
		
КонецФункции

Функция ДопустимыеТипы()

	МассивТипов = Новый Массив;
	МассивТипов.Добавить("Число");
	МассивТипов.Добавить("Строка");
	МассивТипов.Добавить("Булево");
	МассивТипов.Добавить("Дата");
	МассивТипов.Добавить("СписокЗначений");
	МассивТипов.Добавить("МоментВремени");
	
	
	МассивТипов.Добавить("ДинамическийСписок");
	МассивТипов.Добавить("Картинка");
	
	МассивТипов.Добавить("ПолеФормы");
	МассивТипов.Добавить("ГруппаФормы");
	МассивТипов.Добавить("ТаблицаФормы");
	МассивТипов.Добавить("ДекорацияФормы");
	МассивТипов.Добавить("КнопкаФормы");
	
	МассивТипов.Добавить("ТаблицаЗначений");
	МассивТипов.Добавить("ДеревоЗначений");
	
	МассивТипов.Добавить("ПорядокКомпоновкиДанных");
	МассивТипов.Добавить("ОтборКомпоновкиДанных");
	МассивТипов.Добавить("ПоляГруппировкиКомпоновкиДанных");
	МассивТипов.Добавить("УсловноеОформлениеКомпоновкиДанных");
	
	Для каждого Документ Из Метаданные.Документы Цикл
		МассивТипов.Добавить("ДокументСсылка."+Документ.Имя);	
	КонецЦикла; 
	Для каждого Справочник Из Метаданные.Справочники Цикл
		МассивТипов.Добавить("СправочникСсылка."+Справочник.Имя);	
	КонецЦикла; 
	Для каждого Перечисление Из Метаданные.Перечисления Цикл
		МассивТипов.Добавить("ПеречислениеСсылка."+Перечисление.Имя);	
	КонецЦикла; 
	
	Возврат МассивТипов;
	
КонецФункции // ПолучитьДопустимыеТипы()

Функция ПолучитьСтроковоеПредставлениеТипа(ПроверяемыйТип)
	
	ПредставлениеТипа = НовоеСоответствиеПредставленийТипов().Получить(ПроверяемыйТип);
	
	Если ПредставлениеТипа = Неопределено Тогда
	    //Сообщить("Не определен тип "+ПроверяемыйТип);
	КонецЕсли; 
	
	Возврат ПредставлениеТипа;
	
КонецФункции

Функция СтроковоеПредставлениеОписанияТипа(ПроверяемоеОписаниеТипов)
	
	Если ПроверяемоеОписаниеТипов.Типы().Количество() > 0 Тогда
		Возврат "Новый ОписаниеТипов("""+ПолучитьСтроковоеПредставлениеТипа(ПроверяемоеОписаниеТипов.Типы()[0])+""")";
	Иначе
	    Возврат "Неопределено";
	КонецЕсли; 
	
КонецФункции

Функция ТекстовоеПредставлениеЗначения(Значение)
	
	//Для текстовых значений добавляем кавычки в вывод
	//для нетекстовых получаем текстовое представление значения свойства
	ПредставлениеЗначения = Неопределено;
	Если Значение = Неопределено Тогда
		ПредставлениеЗначения = "Неопределено";
	ИначеЕсли ТипЗнч(Значение) = Тип("Строка") Тогда
		ПредставлениеЗначения = """"+Значение+"""";
	ИначеЕсли ТипЗнч(Значение) = Тип("Число") Тогда
		ПредставлениеЗначения = Формат(Значение,"ЧН=; ЧГ=0");
	ИначеЕсли ТипЗнч(Значение) = Тип("Шрифт")
		ИЛИ ТипЗнч(Значение) = Тип("Цвет") Тогда
		ПредставлениеЗначения = ТекстовоеПредставлениеСложногоТипа(Значение)
	Иначе	
		ПредставлениеЗначения = НовоеСоответствиеТекстовыхПредставлений().Получить(Значение);
	КонецЕсли; 
	
	Возврат ПредставлениеЗначения;
	
КонецФункции

Функция ТекстовоеПредставлениеСложногоТипа(Значение)
	
	ПредставлениеТипа = Неопределено;
	Если ТипЗнч(Значение) = Тип("Шрифт") Тогда
		Если Значение.Вид = ВидШрифта.АвтоШрифт Тогда 
			ПредставлениеТипа = "Новый Шрифт()";
		Иначе 
			ИмяШрифта = """"+Значение.Имя+"""";
			Размер = ТекстовоеПредставлениеЗначения(Значение.Размер);
			Жирный = ТекстовоеПредставлениеЗначения(Значение.Жирный);
			Наклонный = ТекстовоеПредставлениеЗначения(Значение.Наклонный);
			Подчеркивание = ТекстовоеПредставлениеЗначения(Значение.Подчеркивание);
			Зачеркивание = ТекстовоеПредставлениеЗначения(Значение.Зачеркивание);
			Масштаб = ТекстовоеПредставлениеЗначения(Значение.Масштаб);
			ПредставлениеТипа = "Новый Шрифт("+ИмяШрифта+","+Размер+","+Жирный+","+Наклонный+","+Подчеркивание+","+Зачеркивание+","+Масштаб+")";	
		КонецЕсли;	
	ИначеЕсли ТипЗнч(Значение) = Тип("Цвет") Тогда
		Если Значение.Вид = ВидЦвета.АвтоЦвет Тогда 
			ПредставлениеТипа = "Новый Цвет()";
		Иначе 
			ПредставлениеТипа = "Новый Цвет("+Значение.Красный+","+Значение.Зеленый+","+Значение.Синий+")";	
		КонецЕсли;	
	Иначе
		//Сюда мы попадать не должны.
		//Функцию вызвали для неподдерживаемого типа
		Сообщить("ПолучитьТекстовоеПредставлениеСложногоТипа:"+ТипЗнч(Значение))
	КонецЕсли; 
	
	Возврат ПредставлениеТипа;
	
КонецФункции 

Функция ПолучитьТекстовоеПредставлениеСложногоТипа(Значение)
	
	ПредставлениеТипа = Неопределено;
	Если ТипЗнч(Значение) = Тип("Шрифт") Тогда
		Если Значение.Вид = ВидШрифта.АвтоШрифт Тогда 
			ПредставлениеТипа = "Новый Шрифт()";
		Иначе 
			ИмяШрифта = """"+Значение.Имя+"""";
			Размер = ПолучитьТекстовоеПредставлениеЗначения(Значение.Размер);
			Жирный = ПолучитьТекстовоеПредставлениеЗначения(Значение.Жирный);
			Наклонный = ПолучитьТекстовоеПредставлениеЗначения(Значение.Наклонный);
			Подчеркивание = ПолучитьТекстовоеПредставлениеЗначения(Значение.Подчеркивание);
			Зачеркивание = ПолучитьТекстовоеПредставлениеЗначения(Значение.Зачеркивание);
			Масштаб = ПолучитьТекстовоеПредставлениеЗначения(Значение.Масштаб);
			ПредставлениеТипа = "Новый Шрифт("+ИмяШрифта+","+Размер+","+Жирный+","+Наклонный+","+Подчеркивание+","+Зачеркивание+","+Масштаб+")";	
		КонецЕсли;	
	ИначеЕсли ТипЗнч(Значение) = Тип("Цвет") Тогда
		Если Значение.Вид = ВидЦвета.АвтоЦвет Тогда 
			ПредставлениеТипа = "Новый Цвет()";
		Иначе 
			ПредставлениеТипа = "Новый Цвет("+Значение.Красный+","+Значение.Зеленый+","+Значение.Синий+")";	
		КонецЕсли;	
	Иначе
		//Сюда мы попадать не должны.
		//Функцию вызвали для неподдерживаемого типа
		Сообщить("ПолучитьТекстовоеПредставлениеСложногоТипа:"+ТипЗнч(Значение))
	КонецЕсли; 
	
	Возврат ПредставлениеТипа;
	
КонецФункции // ПолучитьТекстовоеПредставление()

#КонецОбласти
