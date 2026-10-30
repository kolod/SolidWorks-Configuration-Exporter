
# Include Modern UI
	!include "MUI2.nsh"

# General
	Unicode True
	Name "Configuration Exporter"                                    # Name of the installer (usually the name of the application to install).
	!ifndef OUTFILE
		!define OUTFILE "SolidWorks-Configuration-Exporter-Installer.exe"
	!endif
	OutFile "${OUTFILE}"                                             # name the installer (override with makensis /DOUTFILE=...)
	InstallDir "$PROGRAMFILES64\SW Configuration Exporter"           # Default installing folder ($PROGRAMFILES is Program Files folder).
	InstallDirRegKey HKLM "Software\SW Configuration Exporter" ""    # Get installation folder from registry if available
	ShowInstDetails show                                             # This will always show the installation details.
	ShowUnInstDetails show                                           # This will always show the uninstallation details.
	RequestExecutionLevel admin                                      # Request application privileges for Windows Vista
	SetCompressor /SOLID lzma
	!define APP_MUTEX "SolidWorks-Configuration-Exporter"            # Created by the running application (see App.xaml.cs)

# Variables
	Var StartMenuFolder # Start menu folder

# Interface Settings
	!define MUI_ABORTWARNING          # This will warn the user if they exit from the installer.
	!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"

# Pages
	# Start Menu Folder Page Configuration
	!define MUI_STARTMENUPAGE_REGISTRY_ROOT "HKCU" 
	!define MUI_STARTMENUPAGE_REGISTRY_KEY "Software\Configuration Exporter" 
	!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "Configuration Exporter"
	
	# Run application after install
	!define MUI_FINISHPAGE_RUN "$INSTDIR\Configuration Exporter.exe"
	
	!insertmacro MUI_PAGE_WELCOME                                   # Welcome to the installer page.
	!insertmacro MUI_PAGE_LICENSE "LICENSE"                         # License page
	!insertmacro MUI_PAGE_DIRECTORY                                 # In which folder install page.
	!insertmacro MUI_PAGE_STARTMENU Application $StartMenuFolder    # Start menu page
	!insertmacro MUI_PAGE_INSTFILES                                 # Installing page.
	!insertmacro MUI_PAGE_FINISH                                    # Finished installation page.

	!insertmacro MUI_UNPAGE_CONFIRM
	!insertmacro MUI_UNPAGE_INSTFILES

# Languages
	# Remember the selected language for the uninstaller
	!define MUI_LANGDLL_REGISTRY_ROOT "HKLM"
	!define MUI_LANGDLL_REGISTRY_KEY "Software\SW Configuration Exporter"
	!define MUI_LANGDLL_REGISTRY_VALUENAME "Installer Language"

	# Adds a language and its messages (a language without translated messages fails the build)
	!macro LANGUAGE NAME
		!insertmacro MUI_LANGUAGE "${NAME}"
		!if "${NAME}" == "English"
			LangString MSG_APP_RUNNING 0 "Configuration Exporter is running.$\r$\n$\r$\nClose it and click Retry to continue."
			LangString MSG_NO_RUNTIME 0 "Configuration Exporter requires the .NET 10 Desktop Runtime (x64), which is not installed.$\r$\n$\r$\nOpen the download page?"
		!else if "${NAME}" == "Ukrainian"
			LangString MSG_APP_RUNNING 0 "Configuration Exporter запущено.$\r$\n$\r$\nЗакрийте програму та натисніть «Повторити», щоб продовжити."
			LangString MSG_NO_RUNTIME 0 "Для роботи Configuration Exporter потрібен .NET 10 Desktop Runtime (x64), який не встановлено.$\r$\n$\r$\nВідкрити сторінку завантаження?"
		!else if "${NAME}" == "Afrikaans"
			LangString MSG_APP_RUNNING 0 "Configuration Exporter loop tans.$\r$\n$\r$\nMaak dit toe en klik Probeer weer om voort te gaan."
			LangString MSG_NO_RUNTIME 0 "Configuration Exporter benodig die .NET 10 Desktop Runtime (x64), wat nie geïnstalleer is nie.$\r$\n$\r$\nMaak die aflaaibladsy oop?"
		!else if "${NAME}" == "Albanian"
			LangString MSG_APP_RUNNING 0 "Configuration Exporter po ekzekutohet.$\r$\n$\r$\nMbylleni dhe klikoni Riprovo për të vazhduar."
			LangString MSG_NO_RUNTIME 0 "Configuration Exporter kërkon .NET 10 Desktop Runtime (x64), i cili nuk është i instaluar.$\r$\n$\r$\nTë hapet faqja e shkarkimit?"
		!else if "${NAME}" == "Arabic"
			LangString MSG_APP_RUNNING 0 "Configuration Exporter قيد التشغيل.$\r$\n$\r$\nأغلقه وانقر فوق إعادة المحاولة للمتابعة."
			LangString MSG_NO_RUNTIME 0 "يتطلب Configuration Exporter وجود .NET 10 Desktop Runtime (x64)، وهو غير مثبت.$\r$\n$\r$\nهل تريد فتح صفحة التنزيل؟"
		!else if "${NAME}" == "Armenian"
			LangString MSG_APP_RUNNING 0 "Configuration Exporter-ը գործարկված է։$\r$\n$\r$\nՓակեք այն և սեղմեք «Կրկնել»՝ շարունակելու համար։"
			LangString MSG_NO_RUNTIME 0 "Configuration Exporter-ի համար անհրաժեշտ է .NET 10 Desktop Runtime (x64), որը տեղադրված չէ։$\r$\n$\r$\nԲացե՞լ ներբեռնման էջը։"
		!else if "${NAME}" == "Asturian"
			LangString MSG_APP_RUNNING 0 "Configuration Exporter ta n'execución.$\r$\n$\r$\nZárralu y calca en Retentar pa siguir."
			LangString MSG_NO_RUNTIME 0 "Configuration Exporter rique'l .NET 10 Desktop Runtime (x64), que nun ta instaláu.$\r$\n$\r$\n¿Abrir la páxina de descarga?"
		!else if "${NAME}" == "Basque"
			LangString MSG_APP_RUNNING 0 "Configuration Exporter exekutatzen ari da.$\r$\n$\r$\nItxi eta egin klik Saiatu berriro aurrera jarraitzeko."
			LangString MSG_NO_RUNTIME 0 "Configuration Exporter-ek .NET 10 Desktop Runtime (x64) behar du, eta ez dago instalatuta.$\r$\n$\r$\nDeskarga-orria ireki?"
		!else if "${NAME}" == "Belarusian"
			LangString MSG_APP_RUNNING 0 "Configuration Exporter запушчаны.$\r$\n$\r$\nЗакрыйце праграму і націсніце «Паўтарыць», каб працягнуць."
			LangString MSG_NO_RUNTIME 0 "Для працы Configuration Exporter патрэбны .NET 10 Desktop Runtime (x64), які не ўсталяваны.$\r$\n$\r$\nАдкрыць старонку спампоўкі?"
		!else if "${NAME}" == "Bosnian"
			LangString MSG_APP_RUNNING 0 "Configuration Exporter je pokrenut.$\r$\n$\r$\nZatvorite ga i kliknite Pokušaj ponovo za nastavak."
			LangString MSG_NO_RUNTIME 0 "Configuration Exporter zahtijeva .NET 10 Desktop Runtime (x64), koji nije instaliran.$\r$\n$\r$\nOtvoriti stranicu za preuzimanje?"
		!else if "${NAME}" == "Breton"
			LangString MSG_APP_RUNNING 0 "Emañ Configuration Exporter o vont en-dro.$\r$\n$\r$\nSerrit anezhañ ha klikit war Klask en-dro evit kenderc'hel."
			LangString MSG_NO_RUNTIME 0 "Ezhomm en deus Configuration Exporter eus .NET 10 Desktop Runtime (x64), n'eo ket staliet.$\r$\n$\r$\nDigeriñ ar bajenn bellgargañ?"
		!else if "${NAME}" == "Bulgarian"
			LangString MSG_APP_RUNNING 0 "Configuration Exporter е стартиран.$\r$\n$\r$\nЗатворете го и щракнете върху „Повторен опит“, за да продължите."
			LangString MSG_NO_RUNTIME 0 "Configuration Exporter изисква .NET 10 Desktop Runtime (x64), който не е инсталиран.$\r$\n$\r$\nДа се отвори ли страницата за изтегляне?"
		!else if "${NAME}" == "Catalan"
			LangString MSG_APP_RUNNING 0 "Configuration Exporter s'està executant.$\r$\n$\r$\nTanqueu-lo i feu clic a Reintenta per continuar."
			LangString MSG_NO_RUNTIME 0 "Configuration Exporter requereix el .NET 10 Desktop Runtime (x64), que no està instal·lat.$\r$\n$\r$\nVoleu obrir la pàgina de baixada?"
		!else if "${NAME}" == "Corsican"
			LangString MSG_APP_RUNNING 0 "Configuration Exporter hè in esecuzione.$\r$\n$\r$\nChjudetelu è cliccate nant'à Torna à pruvà per cuntinuà."
			LangString MSG_NO_RUNTIME 0 "Configuration Exporter richiede u .NET 10 Desktop Runtime (x64), chì ùn hè micca installatu.$\r$\n$\r$\nApre a pagina di scaricamentu?"
		!else if "${NAME}" == "Croatian"
			LangString MSG_APP_RUNNING 0 "Configuration Exporter je pokrenut.$\r$\n$\r$\nZatvorite ga i kliknite Pokušaj ponovno za nastavak."
			LangString MSG_NO_RUNTIME 0 "Configuration Exporter zahtijeva .NET 10 Desktop Runtime (x64), koji nije instaliran.$\r$\n$\r$\nOtvoriti stranicu za preuzimanje?"
		!else if "${NAME}" == "Czech"
			LangString MSG_APP_RUNNING 0 "Configuration Exporter je spuštěn.$\r$\n$\r$\nZavřete jej a pokračujte kliknutím na Opakovat."
			LangString MSG_NO_RUNTIME 0 "Configuration Exporter vyžaduje .NET 10 Desktop Runtime (x64), který není nainstalován.$\r$\n$\r$\nOtevřít stránku ke stažení?"
		!else if "${NAME}" == "Danish"
			LangString MSG_APP_RUNNING 0 "Configuration Exporter kører.$\r$\n$\r$\nLuk programmet, og klik på Prøv igen for at fortsætte."
			LangString MSG_NO_RUNTIME 0 "Configuration Exporter kræver .NET 10 Desktop Runtime (x64), som ikke er installeret.$\r$\n$\r$\nVil du åbne downloadsiden?"
		!else if "${NAME}" == "Dutch"
			LangString MSG_APP_RUNNING 0 "Configuration Exporter is actief.$\r$\n$\r$\nSluit het programma en klik op Opnieuw om door te gaan."
			LangString MSG_NO_RUNTIME 0 "Configuration Exporter vereist de .NET 10 Desktop Runtime (x64), die niet is geïnstalleerd.$\r$\n$\r$\nDe downloadpagina openen?"
		!else if "${NAME}" == "Esperanto"
			LangString MSG_APP_RUNNING 0 "Configuration Exporter funkcias.$\r$\n$\r$\nFermu ĝin kaj alklaku Reprovi por daŭrigi."
			LangString MSG_NO_RUNTIME 0 "Configuration Exporter bezonas .NET 10 Desktop Runtime (x64), kiu ne estas instalita.$\r$\n$\r$\nĈu malfermi la elŝutan paĝon?"
		!else if "${NAME}" == "Estonian"
			LangString MSG_APP_RUNNING 0 "Configuration Exporter töötab.$\r$\n$\r$\nSulgege see ja klõpsake jätkamiseks nuppu Proovi uuesti."
			LangString MSG_NO_RUNTIME 0 "Configuration Exporter vajab .NET 10 Desktop Runtime'i (x64), mis pole installitud.$\r$\n$\r$\nKas avada allalaadimisleht?"
		!else if "${NAME}" == "Farsi"
			LangString MSG_APP_RUNNING 0 "Configuration Exporter در حال اجرا است.$\r$\n$\r$\nآن را ببندید و برای ادامه روی «امتحان مجدد» کلیک کنید."
			LangString MSG_NO_RUNTIME 0 "Configuration Exporter به .NET 10 Desktop Runtime (x64) نیاز دارد که نصب نشده است.$\r$\n$\r$\nصفحه دانلود باز شود؟"
		!else if "${NAME}" == "Finnish"
			LangString MSG_APP_RUNNING 0 "Configuration Exporter on käynnissä.$\r$\n$\r$\nSulje se ja jatka valitsemalla Yritä uudelleen."
			LangString MSG_NO_RUNTIME 0 "Configuration Exporter tarvitsee .NET 10 Desktop Runtimen (x64), jota ei ole asennettu.$\r$\n$\r$\nAvataanko lataussivu?"
		!else if "${NAME}" == "French"
			LangString MSG_APP_RUNNING 0 "Configuration Exporter est en cours d'exécution.$\r$\n$\r$\nFermez-le et cliquez sur Réessayer pour continuer."
			LangString MSG_NO_RUNTIME 0 "Configuration Exporter nécessite le .NET 10 Desktop Runtime (x64), qui n'est pas installé.$\r$\n$\r$\nOuvrir la page de téléchargement ?"
		!else if "${NAME}" == "Galician"
			LangString MSG_APP_RUNNING 0 "Configuration Exporter está en execución.$\r$\n$\r$\nPéchao e prema en Tentar de novo para continuar."
			LangString MSG_NO_RUNTIME 0 "Configuration Exporter require o .NET 10 Desktop Runtime (x64), que non está instalado.$\r$\n$\r$\nAbrir a páxina de descarga?"
		!else if "${NAME}" == "Georgian"
			LangString MSG_APP_RUNNING 0 "Configuration Exporter გაშვებულია.$\r$\n$\r$\nდახურეთ იგი და გასაგრძელებლად დააწკაპუნეთ „ხელახლა ცდა“."
			LangString MSG_NO_RUNTIME 0 "Configuration Exporter-ს სჭირდება .NET 10 Desktop Runtime (x64), რომელიც არ არის დაინსტალირებული.$\r$\n$\r$\nგაიხსნას ჩამოტვირთვის გვერდი?"
		!else if "${NAME}" == "German"
			LangString MSG_APP_RUNNING 0 "Configuration Exporter wird ausgeführt.$\r$\n$\r$\nSchließen Sie das Programm und klicken Sie auf Wiederholen, um fortzufahren."
			LangString MSG_NO_RUNTIME 0 "Configuration Exporter benötigt die .NET 10 Desktop Runtime (x64), die nicht installiert ist.$\r$\n$\r$\nDownloadseite öffnen?"
		!else if "${NAME}" == "Greek"
			LangString MSG_APP_RUNNING 0 "Το Configuration Exporter εκτελείται.$\r$\n$\r$\nΚλείστε το και κάντε κλικ στο Επανάληψη για να συνεχίσετε."
			LangString MSG_NO_RUNTIME 0 "Το Configuration Exporter απαιτεί το .NET 10 Desktop Runtime (x64), το οποίο δεν είναι εγκατεστημένο.$\r$\n$\r$\nΆνοιγμα της σελίδας λήψης;"
		!else if "${NAME}" == "Hebrew"
			LangString MSG_APP_RUNNING 0 "Configuration Exporter פועל.$\r$\n$\r$\nסגור אותו ולחץ על נסה שוב כדי להמשיך."
			LangString MSG_NO_RUNTIME 0 "Configuration Exporter דורש את .NET 10 Desktop Runtime (x64), שאינו מותקן.$\r$\n$\r$\nלפתוח את דף ההורדה?"
		!else if "${NAME}" == "Hindi"
			LangString MSG_APP_RUNNING 0 "Configuration Exporter चल रहा है।$\r$\n$\r$\nजारी रखने के लिए इसे बंद करें और पुनः प्रयास करें पर क्लिक करें।"
			LangString MSG_NO_RUNTIME 0 "Configuration Exporter के लिए .NET 10 Desktop Runtime (x64) आवश्यक है, जो इंस्टॉल नहीं है।$\r$\n$\r$\nक्या डाउनलोड पेज खोलें?"
		!else if "${NAME}" == "Hungarian"
			LangString MSG_APP_RUNNING 0 "A Configuration Exporter fut.$\r$\n$\r$\nZárja be, majd a folytatáshoz kattintson az Újra gombra."
			LangString MSG_NO_RUNTIME 0 "A Configuration Exporter működéséhez a .NET 10 Desktop Runtime (x64) szükséges, amely nincs telepítve.$\r$\n$\r$\nMegnyitja a letöltési oldalt?"
		!else if "${NAME}" == "Icelandic"
			LangString MSG_APP_RUNNING 0 "Configuration Exporter er í gangi.$\r$\n$\r$\nLokaðu forritinu og smelltu á Reyna aftur til að halda áfram."
			LangString MSG_NO_RUNTIME 0 "Configuration Exporter þarfnast .NET 10 Desktop Runtime (x64), sem er ekki uppsett.$\r$\n$\r$\nOpna niðurhalssíðuna?"
		!else if "${NAME}" == "Indonesian"
			LangString MSG_APP_RUNNING 0 "Configuration Exporter sedang berjalan.$\r$\n$\r$\nTutup aplikasi ini lalu klik Coba Lagi untuk melanjutkan."
			LangString MSG_NO_RUNTIME 0 "Configuration Exporter memerlukan .NET 10 Desktop Runtime (x64), yang belum terinstal.$\r$\n$\r$\nBuka halaman unduhan?"
		!else if "${NAME}" == "Irish"
			LangString MSG_APP_RUNNING 0 "Tá Configuration Exporter ag rith.$\r$\n$\r$\nDún é agus cliceáil Bain Triail Eile as chun leanúint ar aghaidh."
			LangString MSG_NO_RUNTIME 0 "Teastaíonn .NET 10 Desktop Runtime (x64) ó Configuration Exporter, agus níl sé suiteáilte.$\r$\n$\r$\nAn leathanach íoslódála a oscailt?"
		!else if "${NAME}" == "Italian"
			LangString MSG_APP_RUNNING 0 "Configuration Exporter è in esecuzione.$\r$\n$\r$\nChiudilo e fai clic su Riprova per continuare."
			LangString MSG_NO_RUNTIME 0 "Configuration Exporter richiede .NET 10 Desktop Runtime (x64), che non è installato.$\r$\n$\r$\nAprire la pagina di download?"
		!else if "${NAME}" == "Japanese"
			LangString MSG_APP_RUNNING 0 "Configuration Exporter が実行中です。$\r$\n$\r$\nアプリを閉じてから [再試行] をクリックして続行してください。"
			LangString MSG_NO_RUNTIME 0 "Configuration Exporter には .NET 10 Desktop Runtime (x64) が必要ですが、インストールされていません。$\r$\n$\r$\nダウンロード ページを開きますか?"
		!else if "${NAME}" == "Korean"
			LangString MSG_APP_RUNNING 0 "Configuration Exporter가 실행 중입니다.$\r$\n$\r$\n프로그램을 닫은 후 [다시 시도]를 클릭하여 계속하십시오."
			LangString MSG_NO_RUNTIME 0 "Configuration Exporter를 실행하려면 .NET 10 Desktop Runtime(x64)이 필요하지만 설치되어 있지 않습니다.$\r$\n$\r$\n다운로드 페이지를 여시겠습니까?"
		!else if "${NAME}" == "Kurdish"
			LangString MSG_APP_RUNNING 0 "Configuration Exporter dixebite.$\r$\n$\r$\nWê bigire û ji bo berdewamkirinê li ser Dîsa biceribîne bitikîne."
			LangString MSG_NO_RUNTIME 0 "Configuration Exporter pêdivî bi .NET 10 Desktop Runtime (x64) heye, ku nehatiye sazkirin.$\r$\n$\r$\nRûpela daxistinê vebe?"
		!else if "${NAME}" == "Latvian"
			LangString MSG_APP_RUNNING 0 "Configuration Exporter darbojas.$\r$\n$\r$\nAizveriet to un noklikšķiniet uz Mēģināt vēlreiz, lai turpinātu."
			LangString MSG_NO_RUNTIME 0 "Configuration Exporter darbībai nepieciešams .NET 10 Desktop Runtime (x64), kas nav instalēts.$\r$\n$\r$\nVai atvērt lejupielādes lapu?"
		!else if "${NAME}" == "Lithuanian"
			LangString MSG_APP_RUNNING 0 "Configuration Exporter veikia.$\r$\n$\r$\nUždarykite programą ir spustelėkite Kartoti, kad tęstumėte."
			LangString MSG_NO_RUNTIME 0 "Configuration Exporter reikalingas .NET 10 Desktop Runtime (x64), kuris neįdiegtas.$\r$\n$\r$\nAtidaryti atsisiuntimo puslapį?"
		!else if "${NAME}" == "Luxembourgish"
			LangString MSG_APP_RUNNING 0 "Configuration Exporter leeft.$\r$\n$\r$\nMaacht et zou a klickt op Nach eng Kéier fir weiderzefueren."
			LangString MSG_NO_RUNTIME 0 "Configuration Exporter brauch d'.NET 10 Desktop Runtime (x64), déi net installéiert ass.$\r$\n$\r$\nDownloadsäit opmaachen?"
		!else if "${NAME}" == "Macedonian"
			LangString MSG_APP_RUNNING 0 "Configuration Exporter е стартуван.$\r$\n$\r$\nЗатворете го и кликнете на Обиди се повторно за да продолжите."
			LangString MSG_NO_RUNTIME 0 "Configuration Exporter бара .NET 10 Desktop Runtime (x64), кој не е инсталиран.$\r$\n$\r$\nДа се отвори страницата за преземање?"
		!else if "${NAME}" == "Malay"
			LangString MSG_APP_RUNNING 0 "Configuration Exporter sedang berjalan.$\r$\n$\r$\nTutupnya dan klik Cuba Semula untuk meneruskan."
			LangString MSG_NO_RUNTIME 0 "Configuration Exporter memerlukan .NET 10 Desktop Runtime (x64), yang tidak dipasang.$\r$\n$\r$\nBuka halaman muat turun?"
		!else if "${NAME}" == "Mongolian"
			LangString MSG_APP_RUNNING 0 "Configuration Exporter ажиллаж байна.$\r$\n$\r$\nҮүнийг хааж, үргэлжлүүлэхийн тулд «Дахин оролдох» дээр дарна уу."
			LangString MSG_NO_RUNTIME 0 "Configuration Exporter-д .NET 10 Desktop Runtime (x64) шаардлагатай боловч суулгаагүй байна.$\r$\n$\r$\nТатаж авах хуудсыг нээх үү?"
		!else if "${NAME}" == "Norwegian"
			LangString MSG_APP_RUNNING 0 "Configuration Exporter kjører.$\r$\n$\r$\nLukk programmet og klikk Prøv på nytt for å fortsette."
			LangString MSG_NO_RUNTIME 0 "Configuration Exporter krever .NET 10 Desktop Runtime (x64), som ikke er installert.$\r$\n$\r$\nVil du åpne nedlastingssiden?"
		!else if "${NAME}" == "NorwegianNynorsk"
			LangString MSG_APP_RUNNING 0 "Configuration Exporter køyrer.$\r$\n$\r$\nLat att programmet og klikk Prøv på nytt for å halde fram."
			LangString MSG_NO_RUNTIME 0 "Configuration Exporter krev .NET 10 Desktop Runtime (x64), som ikkje er installert.$\r$\n$\r$\nVil du opne nedlastingssida?"
		!else if "${NAME}" == "Pashto"
			LangString MSG_APP_RUNNING 0 "Configuration Exporter چلېږي.$\r$\n$\r$\nدا وتړئ او د دوام لپاره «بیا هڅه» کېکاږئ."
			LangString MSG_NO_RUNTIME 0 "Configuration Exporter ته .NET 10 Desktop Runtime (x64) اړتیا ده، چې نصب شوی نه دی.$\r$\n$\r$\nد ښکته کولو پاڼه پرانیزئ؟"
		!else if "${NAME}" == "Polish"
			LangString MSG_APP_RUNNING 0 "Configuration Exporter jest uruchomiony.$\r$\n$\r$\nZamknij go i kliknij Ponów próbę, aby kontynuować."
			LangString MSG_NO_RUNTIME 0 "Configuration Exporter wymaga środowiska .NET 10 Desktop Runtime (x64), które nie jest zainstalowane.$\r$\n$\r$\nCzy otworzyć stronę pobierania?"
		!else if "${NAME}" == "Portuguese"
			LangString MSG_APP_RUNNING 0 "O Configuration Exporter está em execução.$\r$\n$\r$\nFeche-o e clique em Repetir para continuar."
			LangString MSG_NO_RUNTIME 0 "O Configuration Exporter requer o .NET 10 Desktop Runtime (x64), que não está instalado.$\r$\n$\r$\nAbrir a página de transferência?"
		!else if "${NAME}" == "PortugueseBR"
			LangString MSG_APP_RUNNING 0 "O Configuration Exporter está em execução.$\r$\n$\r$\nFeche-o e clique em Repetir para continuar."
			LangString MSG_NO_RUNTIME 0 "O Configuration Exporter requer o .NET 10 Desktop Runtime (x64), que não está instalado.$\r$\n$\r$\nAbrir a página de download?"
		!else if "${NAME}" == "Romanian"
			LangString MSG_APP_RUNNING 0 "Configuration Exporter rulează.$\r$\n$\r$\nÎnchideți-l și faceți clic pe Reîncercare pentru a continua."
			LangString MSG_NO_RUNTIME 0 "Configuration Exporter necesită .NET 10 Desktop Runtime (x64), care nu este instalat.$\r$\n$\r$\nDeschideți pagina de descărcare?"
		!else if "${NAME}" == "ScotsGaelic"
			LangString MSG_APP_RUNNING 0 "Tha Configuration Exporter a' ruith.$\r$\n$\r$\nDùin e is briog air Feuch ris a-rithist gus leantainn air adhart."
			LangString MSG_NO_RUNTIME 0 "Feumaidh Configuration Exporter .NET 10 Desktop Runtime (x64) nach eil air a stàladh.$\r$\n$\r$\nA bheil thu airson duilleag na luchdaidh a-nuas fhosgladh?"
		!else if "${NAME}" == "Serbian"
			LangString MSG_APP_RUNNING 0 "Configuration Exporter је покренут.$\r$\n$\r$\nЗатворите га и кликните на Покушај поново да бисте наставили."
			LangString MSG_NO_RUNTIME 0 "Configuration Exporter захтева .NET 10 Desktop Runtime (x64), који није инсталиран.$\r$\n$\r$\nОтворити страницу за преузимање?"
		!else if "${NAME}" == "SerbianLatin"
			LangString MSG_APP_RUNNING 0 "Configuration Exporter je pokrenut.$\r$\n$\r$\nZatvorite ga i kliknite na Pokušaj ponovo da biste nastavili."
			LangString MSG_NO_RUNTIME 0 "Configuration Exporter zahteva .NET 10 Desktop Runtime (x64), koji nije instaliran.$\r$\n$\r$\nOtvoriti stranicu za preuzimanje?"
		!else if "${NAME}" == "SimpChinese"
			LangString MSG_APP_RUNNING 0 "Configuration Exporter 正在运行。$\r$\n$\r$\n请将其关闭，然后单击“重试”继续。"
			LangString MSG_NO_RUNTIME 0 "Configuration Exporter 需要 .NET 10 Desktop Runtime (x64)，但尚未安装。$\r$\n$\r$\n是否打开下载页面？"
		!else if "${NAME}" == "Slovak"
			LangString MSG_APP_RUNNING 0 "Configuration Exporter je spustený.$\r$\n$\r$\nZatvorte ho a pokračujte kliknutím na Opakovať."
			LangString MSG_NO_RUNTIME 0 "Configuration Exporter vyžaduje .NET 10 Desktop Runtime (x64), ktorý nie je nainštalovaný.$\r$\n$\r$\nOtvoriť stránku na stiahnutie?"
		!else if "${NAME}" == "Slovenian"
			LangString MSG_APP_RUNNING 0 "Configuration Exporter se izvaja.$\r$\n$\r$\nZaprite ga in kliknite Poskusi znova za nadaljevanje."
			LangString MSG_NO_RUNTIME 0 "Configuration Exporter potrebuje .NET 10 Desktop Runtime (x64), ki ni nameščen.$\r$\n$\r$\nŽelite odpreti stran za prenos?"
		!else if "${NAME}" == "Spanish"
			LangString MSG_APP_RUNNING 0 "Configuration Exporter se está ejecutando.$\r$\n$\r$\nCiérrelo y haga clic en Reintentar para continuar."
			LangString MSG_NO_RUNTIME 0 "Configuration Exporter requiere .NET 10 Desktop Runtime (x64), que no está instalado.$\r$\n$\r$\n¿Desea abrir la página de descarga?"
		!else if "${NAME}" == "SpanishInternational"
			LangString MSG_APP_RUNNING 0 "Configuration Exporter se está ejecutando.$\r$\n$\r$\nCiérrelo y haga clic en Reintentar para continuar."
			LangString MSG_NO_RUNTIME 0 "Configuration Exporter requiere .NET 10 Desktop Runtime (x64), que no está instalado.$\r$\n$\r$\n¿Desea abrir la página de descarga?"
		!else if "${NAME}" == "Swedish"
			LangString MSG_APP_RUNNING 0 "Configuration Exporter körs.$\r$\n$\r$\nStäng programmet och klicka på Försök igen för att fortsätta."
			LangString MSG_NO_RUNTIME 0 "Configuration Exporter kräver .NET 10 Desktop Runtime (x64), som inte är installerat.$\r$\n$\r$\nVill du öppna nedladdningssidan?"
		!else if "${NAME}" == "Tatar"
			LangString MSG_APP_RUNNING 0 "Configuration Exporter эшли.$\r$\n$\r$\nДәвам итү өчен аны ябыгыз һәм «Кабатлау» төймәсенә басыгыз."
			LangString MSG_NO_RUNTIME 0 "Configuration Exporter өчен .NET 10 Desktop Runtime (x64) кирәк, ул урнаштырылмаган.$\r$\n$\r$\nЙөкләү битен ачаргамы?"
		!else if "${NAME}" == "Thai"
			LangString MSG_APP_RUNNING 0 "Configuration Exporter กำลังทำงานอยู่$\r$\n$\r$\nโปรดปิดโปรแกรม แล้วคลิก ลองใหม่ เพื่อดำเนินการต่อ"
			LangString MSG_NO_RUNTIME 0 "Configuration Exporter ต้องใช้ .NET 10 Desktop Runtime (x64) ซึ่งยังไม่ได้ติดตั้ง$\r$\n$\r$\nเปิดหน้าดาวน์โหลดหรือไม่"
		!else if "${NAME}" == "TradChinese"
			LangString MSG_APP_RUNNING 0 "Configuration Exporter 正在執行。$\r$\n$\r$\n請將其關閉，然後按一下「重試」繼續。"
			LangString MSG_NO_RUNTIME 0 "Configuration Exporter 需要 .NET 10 Desktop Runtime (x64)，但尚未安裝。$\r$\n$\r$\n是否開啟下載頁面？"
		!else if "${NAME}" == "Turkish"
			LangString MSG_APP_RUNNING 0 "Configuration Exporter çalışıyor.$\r$\n$\r$\nDevam etmek için programı kapatın ve Yeniden Dene'ye tıklayın."
			LangString MSG_NO_RUNTIME 0 "Configuration Exporter için .NET 10 Desktop Runtime (x64) gerekiyor, ancak yüklü değil.$\r$\n$\r$\nİndirme sayfası açılsın mı?"
		!else if "${NAME}" == "Uzbek"
			LangString MSG_APP_RUNNING 0 "Configuration Exporter ishlamoqda.$\r$\n$\r$\nDavom etish uchun uni yoping va Qayta urinish tugmasini bosing."
			LangString MSG_NO_RUNTIME 0 "Configuration Exporter uchun .NET 10 Desktop Runtime (x64) kerak, u o'rnatilmagan.$\r$\n$\r$\nYuklab olish sahifasi ochilsinmi?"
		!else if "${NAME}" == "Vietnamese"
			LangString MSG_APP_RUNNING 0 "Configuration Exporter đang chạy.$\r$\n$\r$\nHãy đóng chương trình và bấm Thử lại để tiếp tục."
			LangString MSG_NO_RUNTIME 0 "Configuration Exporter cần .NET 10 Desktop Runtime (x64), nhưng chưa được cài đặt.$\r$\n$\r$\nMở trang tải xuống?"
		!else if "${NAME}" == "Welsh"
			LangString MSG_APP_RUNNING 0 "Mae Configuration Exporter yn rhedeg.$\r$\n$\r$\nCaewch ef a chliciwch Ailgynnig i barhau."
			LangString MSG_NO_RUNTIME 0 "Mae angen .NET 10 Desktop Runtime (x64) ar Configuration Exporter, ac nid yw wedi'i osod.$\r$\n$\r$\nAgor y dudalen lawrlwytho?"
		!else
			!error "No translated messages for language ${NAME}: add them to the LANGUAGE macro"
		!endif
	!macroend

	# All languages from NSIS\Contrib\Language files except Russian; English is the default
	!insertmacro LANGUAGE "English"
	!insertmacro LANGUAGE "Ukrainian"
	!insertmacro LANGUAGE "Afrikaans"
	!insertmacro LANGUAGE "Albanian"
	!insertmacro LANGUAGE "Arabic"
	!insertmacro LANGUAGE "Armenian"
	!insertmacro LANGUAGE "Asturian"
	!insertmacro LANGUAGE "Basque"
	!insertmacro LANGUAGE "Belarusian"
	!insertmacro LANGUAGE "Bosnian"
	!insertmacro LANGUAGE "Breton"
	!insertmacro LANGUAGE "Bulgarian"
	!insertmacro LANGUAGE "Catalan"
	!insertmacro LANGUAGE "Corsican"
	!insertmacro LANGUAGE "Croatian"
	!insertmacro LANGUAGE "Czech"
	!insertmacro LANGUAGE "Danish"
	!insertmacro LANGUAGE "Dutch"
	!insertmacro LANGUAGE "Esperanto"
	!insertmacro LANGUAGE "Estonian"
	!insertmacro LANGUAGE "Farsi"
	!insertmacro LANGUAGE "Finnish"
	!insertmacro LANGUAGE "French"
	!insertmacro LANGUAGE "Galician"
	!insertmacro LANGUAGE "Georgian"
	!insertmacro LANGUAGE "German"
	!insertmacro LANGUAGE "Greek"
	!insertmacro LANGUAGE "Hebrew"
	!insertmacro LANGUAGE "Hindi"
	!insertmacro LANGUAGE "Hungarian"
	!insertmacro LANGUAGE "Icelandic"
	!insertmacro LANGUAGE "Indonesian"
	!insertmacro LANGUAGE "Irish"
	!insertmacro LANGUAGE "Italian"
	!insertmacro LANGUAGE "Japanese"
	!insertmacro LANGUAGE "Korean"
	!insertmacro LANGUAGE "Kurdish"
	!insertmacro LANGUAGE "Latvian"
	!insertmacro LANGUAGE "Lithuanian"
	!insertmacro LANGUAGE "Luxembourgish"
	!insertmacro LANGUAGE "Macedonian"
	!insertmacro LANGUAGE "Malay"
	!insertmacro LANGUAGE "Mongolian"
	!insertmacro LANGUAGE "Norwegian"
	!insertmacro LANGUAGE "NorwegianNynorsk"
	!insertmacro LANGUAGE "Pashto"
	!insertmacro LANGUAGE "Polish"
	!insertmacro LANGUAGE "Portuguese"
	!insertmacro LANGUAGE "PortugueseBR"
	!insertmacro LANGUAGE "Romanian"
	!insertmacro LANGUAGE "ScotsGaelic"
	!insertmacro LANGUAGE "Serbian"
	!insertmacro LANGUAGE "SerbianLatin"
	!insertmacro LANGUAGE "SimpChinese"
	!insertmacro LANGUAGE "Slovak"
	!insertmacro LANGUAGE "Slovenian"
	!insertmacro LANGUAGE "Spanish"
	!insertmacro LANGUAGE "SpanishInternational"
	!insertmacro LANGUAGE "Swedish"
	!insertmacro LANGUAGE "Tatar"
	!insertmacro LANGUAGE "Thai"
	!insertmacro LANGUAGE "TradChinese"
	!insertmacro LANGUAGE "Turkish"
	!insertmacro LANGUAGE "Uzbek"
	!insertmacro LANGUAGE "Vietnamese"
	!insertmacro LANGUAGE "Welsh"

	# Speeds up the language selection dialog
	!insertmacro MUI_RESERVEFILE_LANGDLL

# Ask to close the application while its mutex exists
!macro CheckAppRunning
	check_running:
	System::Call 'kernel32::OpenMutex(i 0x00100000, i 0, t "${APP_MUTEX}") p .R0'
	IntPtrCmp $R0 0 not_running
	System::Call 'kernel32::CloseHandle(p R0)'
	MessageBox MB_RETRYCANCEL|MB_ICONEXCLAMATION "$(MSG_APP_RUNNING)" /SD IDCANCEL IDRETRY check_running
	Abort
	not_running:
!macroend

Function un.onInit
	!insertmacro MUI_UNGETLANGUAGE
	!insertmacro CheckAppRunning
FunctionEnd

# Select the language, check that the application is not running and the .NET 10 Desktop Runtime is installed
Function .onInit
	!insertmacro MUI_LANGDLL_DISPLAY
	!insertmacro CheckAppRunning

	FindFirst $0 $1 "$PROGRAMFILES64\dotnet\shared\Microsoft.WindowsDesktop.App\10.*"
	FindClose $0
	StrCmp $1 "" 0 found
	MessageBox MB_YESNO|MB_ICONEXCLAMATION "$(MSG_NO_RUNTIME)" /SD IDNO IDNO found
	ExecShell "open" "https://dotnet.microsoft.com/download/dotnet/10.0"
	found:
FunctionEnd

# Installer Sections
Section "Install"
	SetShellVarContext all   # Set all or current user for $SMPROGRAMS
	SetOutPath $INSTDIR      # define the output path for this file
	SetOverwrite ifnewer     # Owerwrite if newer
	SetAutoClose false       # Disable autoclose uninstallation page

	# define what to install and place it in the output path
	File LICENSE
	FILE "bin\Release\Configuration Exporter.exe"
	FILE "bin\Release\Configuration Exporter.dll"
	FILE "bin\Release\Configuration Exporter.deps.json"
	FILE "bin\Release\Configuration Exporter.runtimeconfig.json"
	
	WriteUninstaller "$INSTDIR\Uninstall.exe"

	# Store installation folder
	WriteRegStr SHCTX "Software\SW Configuration Exporter" "" $INSTDIR

	!insertmacro MUI_STARTMENU_WRITE_BEGIN Application

		# Save path to shortcuts
		WriteRegStr SHCTX "Software\SW Configuration Exporter" "StartMenuFolder" $StartMenuFolder
		
		# Create shortcuts
		CreateDirectory "$SMPROGRAMS\$StartMenuFolder"
		CreateShortcut "$SMPROGRAMS\$StartMenuFolder\Configuration Exporter.lnk" "$INSTDIR\Configuration Exporter.exe"
		CreateShortcut "$SMPROGRAMS\$StartMenuFolder\Uninstall.lnk" "$INSTDIR\Uninstall.exe"
	!insertmacro MUI_STARTMENU_WRITE_END
SectionEnd

# Uninstaller Section
Section "Uninstall"
	SetShellVarContext all   # Set all or current user for $SMPROGRAMS
	SetAutoClose false       # Disable autoclose uninstallation page
	
	Delete "$INSTDIR\*"
	Delete "$INSTDIR\Uninstall.exe"
	RMDir "$INSTDIR"
	
	ReadRegStr $StartMenuFolder SHCTX "Software\SW Configuration Exporter" "StartMenuFolder" 
	
	Delete "$SMPROGRAMS\$StartMenuFolder\Configuration Exporter.lnk"
	Delete "$SMPROGRAMS\$StartMenuFolder\Uninstall.lnk"
	RMDir "$SMPROGRAMS\$StartMenuFolder"
	
	DeleteRegKey SHCTX "Software\SW Configuration Exporter\StartMenuFolder"
	DeleteRegKey SHCTX "Software\SW Configuration Exporter"
SectionEnd
