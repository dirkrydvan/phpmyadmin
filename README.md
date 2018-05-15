# phpmyadmin für Openshift und OpenTelekomCloud (OTC)

Entält einfach nur phpmyadmin und eine hinzugefügte Konfiguratinsdatei config.inc.php,
welche temorär für Prüfzwecke den Zugriff auf jeden mysql Server erlaubt.

Die enscheidende Konfigzeile lässt in der Anmeldemaske ein zusätzliches Eingabefeld für den Zielserver eerscheinen:
$cfg['AllowArbitraryServer'] = '1';

## Openshift Build Kofiguration
Das Source to Image Verfahren funktioniert nur in Openshift mit speziell dafür vorbereiteten Base Images.
Diese enthalten zusätzlich zu den benötigten Betriebsystem und Middleware ebenfalls Skripte zum abholen, ggf. Kompilieren und Ablegen der Programme aus einem Git-Repository.

PHPmyadmin ist eien PHP Anwendung und deshalb muss ein Base Image mit PHP, Webserver und den spzeieleln Skripten genutzt werden:
"php-71-rhel7" --> registry.access.redhat.com/rhscl/php-71-rhel7

Die PHPmyadmin Anwendung slebst muss einfach auf einem Git-repository abgelegt sein:
https://github.com/dirkrydvan/phpmyadmin

build-phpmyadmin-arbitary-s2i.yaml
apiVersion: v1
kind: BuildConfig
metadata:
  name: phpmyadmin
  namespace: infra
  labels:
    app: phpmyadmin
    app-version: phpmyadmin-0.1
    version: '0.1'
spec:
  triggers: []
  runPolicy: Serial
  source:
    type: Git
    git:
      uri: 'https://github.com/dirkrydvan/phpmyadmin'
  strategy:
    type: Source
    sourceStrategy:
      from:
        kind: DockerImage
        name: registry.access.redhat.com/rhscl/php-71-rhel7
  output:
    to:
      kind: ImageStreamTag
      name: 'phpmyadmin:0.1'
status:
