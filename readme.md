# OSV2020-U Onderzoek en Scripts

## Aanleiding

Voor de gemeentelijke herindelingsverkiezing van november 2020 stelt de [Kiesraad](https://www.kiesraad.nl) versie 1.2.0.1 van de OSV2020-U software beschikbaar.
Van deze software heeft de kiesraad de broncode vrijgegeven.
Deze is te downloaden van de pagina [Broncode OSV2020-u](https://www.kiesraad.nl/adviezen-en-publicaties/formulieren/2020/10/5/broncode-osv2020-u).
Dit ook in het kader van [Bijlage 2 van de Kieswet](https://wetten.overheid.nl/BWBR0034180/2021-01-01/#Bijlage2).
> Eisen aan de programmatuur die door de centrale stembureaus wordt gebruikt ten behoeve van de vaststelling van de uitslag van verkiezingen of de berekening van de zetelverdeling

Artikel g:

> de programmatuur wordt als open source ontwikkeld en maakt gebruik van open standaarden. Indien dit aantoonbaar niet mogelijk is wordt technologie toegepast waarvan de doeltreffendheid in de praktijk is aangetoond en die direct toepasbaar is. Voor verkiezings gegevens zoals kandidatenlijsten en zetelverdeling wordt de EML_NL standaard toegepast;

## Onderzoek

De overheid heeft als streven om steeds meer broncode vrij te geven. Zie ook [digitale overheid: broncodes-van-de-overheid-vrijgeven-vanaf-2021](https://www.digitaleoverheid.nl/nieuws/broncodes-van-de-overheid-vrijgeven-vanaf-2021/).
Maar wat is dan broncode vrijgeven?
Broncode vrijgeven kan in vele vormen, van simpel een bestandje om te downloaden tot een open community waarin alles open wordt ontwikkeld, zoals wordt gepromoot door de organisatie [publiccode](https://publiccode.net/).

Om de lat niet al te hoog te leggen, geef ik hier een lijstje met minimale eisen waaraan vrijgegeven broncode zou moeten voldoen.

1. **Er moet een duidelijke open source licentie zijn aangeven.**
Het hebben van een open source licentie maakt duidelijk wat de rechten en plichten zijn met betrekking tot het gebruik van de broncode.

1. **De broncode moet compileerbaar zijn.**
Om broncode om te zetten in voor computer leesbare code moet de broncode gecompileerd worden.
Dit maak het mogelijk om de broncode ook daadwerkelijk te gebruiken.
Maar ook om analyses te doen door zelf delen van de broncode te testen.
Vaak zijn er scripts beschikbaar waarin beschreven is hoe de broncode moet worden omgezet.
Deze zullen dan ook meegeleverd moeten worden.
Ook wordt gebruik gemaakt van niet zelf ontwikkelde bibliotheken.
Ook deze bibliotheken moeten beschikbaar zijn of aangegeven hoe deze bibliotheken kunnen worden verkregen.

1. **Alle basis broncode moet beschikbaar zijn.**
Soms worden delen van de broncode gegenereerd.
Hierbij wordt op basis van een meta beschrijving broncode gegenereerd.
Om broncode te publiceren waarop doorontwikkeld kan worden is het onvoldoende om alleen de gegenereerde broncode vrij te geven.
Daarom moet alle broncode worden vrijgegeven.

1. **De geautomatiseerde testen moeten beschikbaar zijn.**
Als het goed is wordt broncode getest.
Bij een goed ontwikkeld systeem zijn daarvoor geautomatiseerde tests ontwikkeld.
Met deze tests kan eenvoudig worden gecontroleerd of bij een wijziging er geen nieuwe bugs worden geïntroduceerd.
Voor zowel de analyse van een systeem als het kunnen doorontwikkelen van vrijgegeven broncode zijn deze tests essentieel.
Daarom moet als de broncode wordt vrijgegeven deze tests meegeleverd worden.

Deze lijst is niet allesomvattend.
Maar bevat wel een minimale lijst waaraan het vrijgeven van broncode zou moeten voldoen.
Het zou goed zijn als zo'n lijst zelf door de overheid wordt vrijgeven.

## Onderzoeksresultaten van de OSV2020-U broncode

Met de bovengenoemde lijst als referentie is de broncode van de OSV2020-U onderzocht.
De software is vrijgeven als in 1 zip bestand.
In dit bestand zit de broncode van de OSV2020-U software.
De vrijgegeven software is tegen bovengenoemde lijst gehouden.
Daar zijn de volgende bevindingen uit gekomen.

### 1. Er moet een duidelijke open source licentie zijn aangeven
Met de broncode is geen duidelijke licentie meegeleverd.
Er is alleen een bestandje `licentie_statement.txt` met de volgende tekst meegeleverd:

```
# Licentie statement broncode OSV2020-U versie 1.2.0.1

De gepubliceerde broncode van OSV2020-U is bestemd om een indruk te kunnen
krijgen van de functionaliteit van de software op broncode niveau. Hiermee
wordt beoogd bij te dragen aan de transparantie van het verkiezingsproces.

De gebruiker van de broncode mag deze bestuderen en analyseren, het
distribueren van de broncode of de daarvan afgeleide werken aan derden is niet
toegestaan.
```

Dit is niet echt zoals je zou verwachten als iets open source is.
Want bij open source heb je juist wel het recht om de verspreiden.
En ook niet zoals door de overheid zelf als open source gedefinieerd.

> Daarnaast kunnen via open source licenties afspraken worden gemaakt over het (her)gebruik, zoals het aanpassen en verder verspreiden van de broncode.

Bron: https://www.digitaleoverheid.nl/dossiers/oss-kennisnetwerk/

**Conclusie: Dit is geen open source**

### 2. De broncode moet compileerbaar zijn
De vrijgegeven broncode is niet compileerbaar.
De scripts om te compileren zijn eerder toevallig vrijgegeven dan bewust.
Dit komt omdat het process dat gebruikt is bij de broncode deze scripts (`pom.xml`) in bepaalde directories opslaat bij compilaties.
Directories die meegenomen zijn in het geleverde zipbestand.
Maar die scripts zijn niet volledig.
Om te vrijgegeven broncode alsnog compileerbaar te maken moeten deze scripts worden verplaatst en ook de directory structuur van de broncode worden aangepast.
Wanneer dit gedaan worden blijken er nog andere bevindingen te zijn.
In de broncode wordt gebruik gemaakt van een aantal bibliotheken waarvan de broncode niet beschikbaar is, maar die ook niet vrij beschikbaar zijn en door de leverancier ontwikkeld zijn.
Het gaat om de volgende bibliotheken:
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

**Conclusie: Met wat hang en vliegwerk is het mogelijk om de broncode te compileren, maar deze vorm is onvoldoende**

### 3. Alle basis broncode moet beschikbaar zijn
In de code zijn op een aantal plaatsen code generators gebruikt.
Echter in de gepubliceerde broncode is wel het resultaat van de generators te vinden.
Een ook wel, maar mogelijk niet alle, meta data waaruit deze bestanden gegenereerd zijn.
De tool om de generatie uit te voeren ontbreekt.
Hierdoor is niet vast te stellen wat de generatie doet of deze zelf uit te voeren.
Het is ook niet mogelijk om hier op door te ontwikkelen zonder de leverancier.

**Conclusie: Niet vast te stellen of alle broncode is vrijgegeven en er een leveranciersafhankelijkheid**

### 4. De geautomatiseerde testen moeten beschikbaar zijn
Uit de broncode blijkt duidelijk dat er testen ontwikkeld zijn.
Het build process bevat namelijk referenties naar deze tests.
Echter in de vrijgegeven broncode is niets terug te vinden.

**Conclusie: Geen tests beschikbaar**

## Conclusie en Aanbevelingen

Het is goed dat de kiesraad de broncode heeft vrijgegeven.
Maar op basis van minimaal verwacht zou mogen worden voor het vrijgeven van broncode is het volstrekt onvoldoende.
Nu kan worden aangedragen dat deze criteria niet vastgesteld of geëist zijn.
En juist daarom zou het goed zijn om dit soort criteria wel vast te leggen.
Overigens heb ik de kiesraad op 10 december 2020 om op gevraagd om meer informatie over bovengenoemde onvolledigheden te geven (en bevestiging van ontvangst gekregen).
Maar tot op heden (27 januari 2021) nog niets gehoord.

# Scripts en zelf onderzoek doen

Omdat de code te analyseren is het gewenst om de software te kunnen compileren.
Nu is dat niet direct mogelijk met de geleverde broncode.
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
1. De broncode die gedownload kan worden van de website van de kiesraad: [Broncode OSV2020-u versie 1.2.0.1](https://www.kiesraad.nl/adviezen-en-publicaties/formulieren/2020/10/5/broncode-osv2020-u)
1. De installatie versie van OSV2020-U versie KS. (Helaas is die versie (27 januari 2021) niet meer beschikbaar via de website. Wellicht dat deze met een e-mail naar de kiesraad deze verkregen kan worden. Ik verwacht dat voor nieuwe verkiezingen nieuwe versies beschikbaar komen)

Als de tools zijn geïnstalleerd zijn en de je hebt de OSV2020-u software dan kun je met de volgende stappen de code omzetten.

### Installeren van missende biblioteken.
Hiervoor is de geïnstalleerde OSV2020-U software nodig.
1. Installer de OSV2020-U software. Opstarten is niet nodig.
1. Run het script `install_libs.bash` met als argument de directory waar je de osv2020-u software hebt geinstalleerd.
De juiste directory is de directory waar het bestand `nl-was-war.war` aanwezig is.

### Verander en patch de broncode automatisch met het script
De volgende stap is om de broncode te patchen.
1. Run het script `modify.bash` met als argument de directory waar de je de OSV2020-U broncode heb neergezet.
Dat is de directory waar alle `elect-*` and `nl-*` directories in staan.
Het script verplaatst de broncode en patcht de pom.xml bestanden.
**Run het script vanuit de directory waar het script `modify.bash` staat!**

### Bouw de broncode
Ga naar directory waar de broncode staat en run maven:
`mvn install`

Als goed is moet je nu succesvol alle modules gebouwd hebben.


<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License</a>.
