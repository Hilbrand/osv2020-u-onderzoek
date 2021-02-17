# OSV2020-U Scripts

De [Kiesraad](https://www.kiesraad.nl) stelt software beschikbaar ter ondersteuning van het tellen van de stemmen.
Van deze software heeft de kiesraad de broncode vrijgegeven.
Deze is te downloaden van de website van de Kiesraad.
Bij elke nieuwe verkiezingen wordt deze software aangepast en een nieuwe versie beschikbaar gesteld.
Met de vrijgave van versie 1.2.0.1 voor de Gemeenteraadverkiezingen 2020 ben ik begonnen met te kijken naar wat er nu aan broncode is vrijgegeven.
Hierover het ik een artikel geschreven: [Broncode vrijgeven is niet hetzelfde als open source](https://opensource.pleio.nl/blog/view/3e779adf-680f-4588-b750-fd3318aaf0da/broncode-vrijgeven-is-niet-hetzelfde-als-open-source-over-osv2020-u-van-de-kiesraad).
In dat artikel geef ik aan waarom, zoals de titel al zegt, de vrijgegeven broncode geen open source is
en waar het minimaal aan zou moeten voldoen.
Zoals ook in het artikel vermeld is het niet mogelijk om de broncode te compileren in de vorm waarin het wordt vrijgegeven.
Om dit toch te kunnen heb ik een script geschreven dat een aantal transformaties op de broncode uitvoert zodat het compileerbaar wordt.

Dit is niet ideaal en ook, omdat de aangeleverde broncode niet volledig is.
In de broncode wordt gebruik gemaakt van een aantal bibliotheken waarvan de broncode niet beschikbaar is,
maar die ook niet vrij beschikbaar zijn en door de leverancier ontwikkeld zijn.
In versie 1.2.0.1 (versie Gemeenteraadsverkiezingen 2020) gaat het om de volgende bibliotheken:
```
document-generator-annotations-2.4.1
document-generator-generator-2.4.1
document-generator-core-2.4.1
document-generator-odt-2.4.1
velocity-template-engine-core-2.2.0
velocity-template-engine-interfaces-2.2.0
ivu-jsefa-addon-1.1.0
opendocument-2.1.0
```

Een van die bibliotheken `opendocument-2.1.0` lijkt een door de leverancier opnieuw verpakte versie van `jopendocument 1.3.b1` (http://www.jopendocument.org/).
Deze bibliotheek is onder duale licentie beschikbaar namelijk GPL of commercieel.
Ik kan nergens vinden onder welke licentie deze bibliotheek gebruikt is.
Maar als dat GPL is dan zou de gehele applicatie onder GPL moeten worden vrijgegeven.
Als de bibliotheek onder commerciële licentie is gekocht, dan had dit toch wel ergens gemeld moeten worden.

Ook ontbreekt de database schema module (`elect-model-db`)

In de code zijn op een aantal plaatsen code generators gebruikt.
Echter in de gepubliceerde broncode is wel het resultaat van de generators te vinden.
Een ook wel, maar mogelijk niet alle, meta data waaruit deze bestanden gegenereerd zijn.
De tool om de generatie uit te voeren ontbreekt.
Hierdoor is niet vast te stellen wat de generatie doet of deze zelf uit te voeren.
Het is ook niet mogelijk om hier op door te ontwikkelen zonder de leverancier.

Ik heb de kiesraad op 10 december 2020 gevraagd om meer informatie over bovengenoemde onvolledigheden te geven (en bevestiging van ontvangst gekregen).
Maar tot op heden (3 Maart 2021) nog niets gehoord.

# Scripts en zelf onderzoek doen

Omdat de broncode te kunnen analyseren is het gewenst om de software te kunnen compileren.
Omdat de broncode niet door derden mag worden verspreid heb ik een script geschreven dat de broncode omzet.
Hier zijn een aantal zaken voor nodig:
1. Linux (of unix-achtige omgeving)
1. dos2unix
1. bash shell
1. Java 11
1. Maven
1. Git

**Disclaimer: Dit process gebruikt scripts die bestanden op je filesysteem aanpassen en kan dus potentieel gegevens verwijderen. Het is getest, dus dit zou niet moeten gebeuren. Maar voor de volledigheid: Het gebruik is op eigen risico.**


Verder is nodig:
1. De broncode die gedownload kan worden van de website van de kiesraad: [Broncode OSV2020-u versie 1.3.9](https://www.kiesraad.nl/adviezen-en-publicaties/formulieren/2021/02/01/broncode-osv2020-u)
1. Voor de ontbrekende bibliotheken is een installatie versie van OSV2020-U Uitslagvasttelling nodig. Deze versie was eerder 
beschikbaar op aanvraag, maar op de website van de kiesraad lijkt deze alleen via cd te worden aangeleverd. 


Als de tools zijn geïnstalleerd zijn en je hebt de OSV2020-u software dan kun je met de volgende stappen de code omzetten.

### Installeren van missende biblioteken.
Hiervoor is de geïnstalleerde OSV2020-U versie 1.2.0.1 software nodig.
Stappen die gedaan moeten worden om de missende bibliotheken te installeren.
1. Installer de OSV2020-U software. Opstarten is niet nodig.
1. Run het script `install_libs.bash` met als argument de directory waar je de osv2020-u software hebt geinstalleerd.
De juiste directory is de directory waar het bestand `nl-was-war.war` aanwezig is.

*De ontbrekende biblioteken zijn gebaseerd op de versie 1.2.0.1 van de OSV202-u software omdat 1.3.9 nog niet beschikbaar was bij het aanpassen van het script.
Als je versie 1.3.9 hebt van de software kan het zijn dat de versies van de meegeleverde bibliotheken is aangepast,
In dat geval moet je het script aanpassen om de juiste versies te installeren.
Ook moeten dan deze versies aangepast worden in de pom.xml*

### Verander en patch de broncode automatisch met het script
De volgende stap is om de broncode te patchen.
1. Start het script `modify.bash` met als argument de directory waar de je de OSV2020-U broncode heb neergezet.
Dat is de directory waar alle `elect-*` and `nl-*` directories in staan.
Het script verplaatst de broncode en patcht de pom.xml bestanden.
**Start het script vanuit de directory waar het script `modify.bash` staat!**

*De patch stap is ook uit te voeren zonder installatie van missende bibliotheken.
Alleen zal de broncode dan niet volledig compileren.*

*De laatste stap van het script is een patch voor missende Java classen uit de missende bibliotheken.
Deze missen omdat het script uitgaat van de biblioheken van versie 1.2.0.1 van OSV2020-U.
Indien bibliotheken van versie 1.3.9 gebruikt zouden worden kan patch `ovs2020-u-dummy.patch` worden overgeslagen.*

### Bouw de broncode
Ga naar directory waar de broncode staat en run maven:
`mvn install`

Als goed is moet je nu succesvol alle modules gebouwd hebben.

<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License</a>.
