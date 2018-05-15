# phpmyadmin für Openshift und OpenTelekomCloud (OTC)

Entält einfach nur phpmyadmin und eine hinzugefügte Konfiguratinsdatei config.inc.php,
welche temorär für Prüfzwecke den Zugriff auf jeden mysql Server erlaubt.

Die enscheidende Konfigzeile lässt in der Anmeldemaske ein zusätzliches Eingabefeld für den Zielserver eerscheinen:
$cfg['AllowArbitraryServer'] = '1';

## Openshift Build Konfiguration (Source/S2I Strategie nicht Docker Strategie)
Das Source to Image Verfahren funktioniert nur in Openshift mit speziell dafür vorbereiteten Base Images.
Diese enthalten zusätzlich zu den benötigten Betriebsystem und Middleware ebenfalls Skripte zum abholen, ggf. Kompilieren und Ablegen der Programme aus einem Git-Repository.

> Obacht! Kein Dockerfile!
>Da die speziellen Skripte im vorbereiteten S2I Image das Anwendungs-Image aufbauen, sind keine direkten Docker Befehle und kein Dockerfile als Bauanleitung vom Nutzer anzugeben.

PHPmyadmin ist eine PHP Anwendung und deshalb muss ein Base Image mit PHP, Webserver und den speziellen Skripten genutzt werden:
"php-71-rhel7" --> https://access.redhat.com/containers/?tab=tech-details#/registry.access.redhat.com/rhscl/php-71-rhel7

Die PHPmyadmin Anwendung slebst muss einfach auf einem Git-repository abgelegt sein:
https://github.com/dirkrydvan/phpmyadmin

Das Openshift-Projekt bzw. Kubernetes-Namespace "Werkzeugprojekt" wurde schon angelegt.


___YAML-Datei build-phpmyadmin-arbitary-s2i.yaml___
```yaml
apiVersion: v1
kind: BuildConfig
metadata:
  name: phpmyadmin
  namespace: werkzeugprojekt
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
```

## Build Konfiguration in Openshift speichern

Das kann per Weboberflöche oder Komandozeile geschehen. 
Hier wird oc genutzt. Das "oc" Programm wurde schon vorher lokal installiert.

```bash
dirkrydvan@workstation: oc create -f build-phpmyadmin-arbitary-s2i.yaml
```

## Build starten

Das Openshift-Projekt bzw. Kubernetes-Namespace "Werkzeugprojekt" wurde schon angelegt.
Nun kann der Build gestartet werden. 

```bash
dirkrydvan@workstation: oc start-build -n werkzeugprojekt phpmyadmin --follow=true
build "phpmyadmin-13" started
Cloning "https://github.com/dirkrydvan/phpmyadmin" ...
        Commit: 704846f8a59cee72ba001e7e519606f6e03489d4 (copy)
        Author: Dirk <dirk>
        Date:   Tue May 15 16:23:56 2018 +0200

---> Installing application source...
Found 'composer.json', installing dependencies using composer.phar...
Downloading https://getcomposer.org/installer, attempt 1/6
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  298k  100  298k    0     0   676k      0 --:--:-- --:--:-- --:--:--  676k
All settings correct for using Composer
Downloading...

Composer (version 1.6.5) successfully installed to: /opt/app-root/src/composer.phar
Use it: php composer.phar

Loading composer repositories with package information
Installing dependencies (including require-dev) from lock file
Warning: The lock file is not up to date with the latest changes in composer.json. You may be getting outdated dependencies. Run update to update them.
Package operations: 30 installs, 0 updates, 0 removals
  - Installing psr/log (1.0.2): Downloading (100%)
  - Installing symfony/debug (v2.8.38): Downloading (100%)
  - Installing symfony/console (v2.8.38): Downloading (100%)
  - Installing symfony/process (v2.8.38): Downloading (100%)
  - Installing gitonomy/gitlib (v1.0.3): Downloading (100%)
  - Installing codacy/coverage (1.4.2): Downloading (100%)
  - Installing phpdocumentor/reflection-common (1.0.1): Downloading (100%)
  - Installing phpdocumentor/type-resolver (0.3.0): Downloading (100%)
  - Installing squizlabs/php_codesniffer (3.2.3): Downloading (100%)
  - Installing phpmyadmin/coding-standard (0.3): Downloading (100%)
  - Installing sebastian/recursion-context (1.0.5): Downloading (100%)
  - Installing sebastian/exporter (1.2.2): Downloading (100%)
  - Installing sebastian/diff (1.4.3): Downloading (100%)
  - Installing sebastian/comparator (1.2.4): Downloading (100%)
  - Installing webmozart/assert (1.3.0): Downloading (100%)
  - Installing phpdocumentor/reflection-docblock (3.2.2): Downloading (100%)
  - Installing doctrine/instantiator (1.0.5): Downloading (100%)
  - Installing phpspec/prophecy (1.7.6): Downloading (100%)
  - Installing sebastian/version (1.0.6): Downloading (100%)
  - Installing sebastian/environment (1.3.8): Downloading (100%)
  - Installing phpunit/php-token-stream (1.4.12): Downloading (100%)
  - Installing phpunit/php-text-template (1.2.1): Downloading (100%)
  - Installing phpunit/php-file-iterator (1.4.5): Downloading (100%)
  - Installing phpunit/php-code-coverage (2.2.4): Downloading (100%)
  - Installing phpunit/php-timer (1.0.9): Downloading (100%)
  - Installing phpunit/phpunit-mock-objects (2.3.8): Downloading (100%)
  - Installing symfony/yaml (v2.8.38): Downloading (100%)
  - Installing sebastian/global-state (1.1.1): Downloading (100%)
  - Installing phpunit/phpunit (4.8.36): Downloading (100%)
  - Installing phpunit/phpunit-selenium (1.4.2): Downloading (100%)
symfony/console suggests installing symfony/event-dispatcher ()
phpunit/php-code-coverage suggests installing ext-xdebug (>=2.2.1)
sebastian/global-state suggests installing ext-uopz (*)
phpunit/phpunit suggests installing phpunit/php-invoker (~1.1)
Generating optimized autoload files
=> sourcing 20-copy-config.sh ...
---> 14:44:56     Processing additional arbitrary httpd configuration provided by s2i ...
=> sourcing 00-documentroot.conf ...
=> sourcing 50-mpm-tuning.conf ...
=> sourcing 40-ssl-certs.sh ...


Pushing image 172.30.119.75:5000/werkzeugprojekt/phpmyadmin:0.1 ...
Pushed 5/6 layers, 84% complete
Pushed 6/6 layers, 100% complete
Push successful
dirkrydvan@workstation:$ 
```

### Deployment Konfiguration

```yaml
kind: "DeploymentConfig"
apiVersion: "v1"
metadata:
  name: "phpmyadmin"
spec:
  template:
    metadata:
      labels:
        name: "phpmyadmin"
    spec:
      containers:
        - name: "phpmyadmin"
          image: "phpmyadmin:0.1"
          ports:
            - containerPort: 8080
              protocol: "TCP"
  replicas: 5
  selector:
    name: "phpmyadmin"
  triggers:
    - type: "ConfigChange"
    - type: "ImageChange"
      imageChangeParams:
        automatic: true
        containerNames:
          - "phpmyadmin"
        from:
          kind: "ImageStreamTag"
          name: "phpmyadmin:0.1"
  strategy:
```


### Service Konfiguration

```yaml
apiVersion: v1
kind: Service
metadata:
  name: phpmyadmin
  namespace: werkzeugprojekt
  labels:
    app: phpmyadmin
spec:
  ports:
    - name: phpmyadmin
      protocol: TCP
      port: 8080
      targetPort: 8080
  selector:
    deploymentconfig: phpmyadmin
  type: ClusterIP
  sessionAffinity: None
status:
```

### Route anlegen

```yaml
apiVersion: v1
kind: Route
metadata:
  name: phpmyadmin
  namespace: werkzeugprojekt
  labels:
    app: phpmayadmin
spec:
  host: phpmyadmin-werkzeugprojekt.augustusburg.org
  to:
    kind: Service
    name: phpmyadmin
    weight: 100
  port:
    targetPort: phpmyadmin
  tls:
    termination: edge
  wildcardPolicy: None
status:
```
