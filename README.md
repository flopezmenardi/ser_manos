# Ser Manos

## Contributors

- Felix Lopez Menardi
- Joaquin Girod
- Manuel Dithurbide

## Stack Tecnológico

Para el desarrollo de la aplicación se eligió un stack tecnológico simple, coherente y eficiente, priorizando un bajo costo de mantenimiento, una curva de aprendizaje accesible y un fuerte soporte de la comunidad. Las decisiones técnicas siguen las mejores prácticas recomendadas por la comunidad Flutter y los docentes involucrados en el proyecto.

### Framework principal

- **Flutter**
  Framework multiplataforma que permite compartir la mayoría del código entre iOS y Android. Acelera el desarrollo y reduce los costos de mantenimiento.

### Gestión de navegación

- **go\_router (`^16.0.0`)**
  Se eligió `go_router` por su integración oficial con Flutter, su soporte para navegación declarativa, rutas anidadas y redirecciones. Su simplicidad lo convierte en una solución escalable y fácil de mantener.

### Arquitectura y manejo de estado

- **Riverpod (`flutter_riverpod: ^2.5.1`, `hooks_riverpod: ^2.4.0`, `flutter_hooks: ^0.21.2`)**
  Riverpod se adoptó como solución de gestión de estado por su enfoque declarativo, su independencia del árbol de widgets y su excelente integración con la programación reactiva. Facilita la separación de responsabilidades y mejora la testabilidad del código.

### Backend y servicios

- **Firebase**
  Se utilizó como backend-as-a-service (BaaS) para acelerar el desarrollo y evitar la gestión directa de infraestructura. Se integraron los siguientes módulos:

  - `firebase_core: ^3.13.0`
  - `cloud_firestore: ^5.6.7` — Base de datos NoSQL en tiempo real.
  - `firebase_auth: ^5.5.3` — Autenticación de usuarios.
  - `firebase_analytics: ^11.4.6` — Analítica de uso.
  - `firebase_crashlytics: ^4.3.6` — Reporte de errores en producción.
  - `firebase_remote_config: ^5.4.5` — Configuración remota dinámica.
  - `firebase_storage: ^12.1.0` — Almacenamiento de archivos multimedia.

### Herramientas complementarias

- **Geolocalización y mapas:**

  - `geolocator: ^14.0.1` — Acceso a la ubicación del dispositivo.

- **Integración con el sistema operativo:**

  - `url_launcher: ^6.2.4` — Apertura de enlaces externos.
  - `share_plus: ^11.0.0` — Compartir contenido mediante apps del dispositivo.

- **Captura y carga de imágenes:**

  - `image_picker: ^1.1.0` — Selección de imágenes desde la cámara o galería.

- **Gestión de permisos en runtime:**

  - `permission_handler: ^12.0.0+1`.

- **Formularios avanzados y validación:**

  - `flutter_form_builder: ^10.0.1`
  - `form_builder_validators: ^11.1.2`.

- **Internacionalización (aún no implementada):**

  - `intl: ^0.19.0`.

- **Renderizado de Markdown:**

  - `flutter_markdown: ^0.7.7+1`.

- **HTTP Requests:**

  - `http: ^1.1.0`.

- **Almacenamiento local:**

  - `path_provider: ^2.1.5`.

### Testing y herramientas de desarrollo

- **Testing unitario y mocks:**

  - `mockito: ^5.4.4`
  - `fake_cloud_firestore: ^3.1.0`

- **Generación automática de código:**

  - `build_runner: ^2.4.8`

- **Íconos personalizados para múltiples plataformas:**

  - `flutter_launcher_icons: ^0.14.4`

## Metrics & Feature Flagging

Para la activación de las features se puede ir a la remote config y alterar los valores de las variables `show_like_counter` y `show_proximity_button`.
Intentamos mantener estos dos puntos lo más cercanos posibles y que se retroalimenten, generando una especie de narrativa a partir de la feature y medir qué tan correcta es nuestra imaginación con una métrica (básicamente hipotetizar y verificar). Al mismo tiempo no queríamos que la métrica dependiera únicamente de la feature, o sea que si la feature está desactivada la métrica recaude información de todas maneras, así que hilamos fino en busca de métricas que fueran globales pero útiles para las nuevas features.

### Features

![Main Screen with extra features](https://firebasestorage.googleapis.com/v0/b/ser-manos-d9350.firebasestorage.app/o/Screenshot%20from%202025-07-01%2009-21-44.png?alt=media&token=48929974-9b2e-4f74-90c0-0fde703a9b8a)

**Sorting Button**: permite elegir entre ordenar por frescura o por geolocalización, el default siendo frescura.
Creemos que la aplicación probablemente crezca a una red social donde organizaciones caritativas buscan obtener tracción y sponsors, perdiendo esa identidad totalmente funcional de oferta y postulación. Al fin y al cabo queremos que el usuario abra nuestra aplicación todos los días, no simplemente cuando se le urge inscribirse en un voluntariado, por esto priorizar y mantener como default la vejez nos parece la decisión correcta para mantener el engagement.
Tampoco nos agradaba la idea de que lo primero que vea un usuario en su primer registro, al entrar al home de la aplicación sea un pop up pidiéndole permiso para usar la geolocalización. Otorgar la libertad de pasar al ordenamiento por cercanía nos pareció más constructivo y no tan invasivo. Como punto al margen, el botón no está posicionado en un lugar óptimo, ocupando demasiado espacio valioso en la primer sección del feed.
De todas maneras entendemos esta versión como un paso intermedio, recalcando que la aplicación crecería a tener una página dedicada al feed para mantener el engagement y tal vez otra página dedicada exclusivamente a la búsqueda de un voluntariado.

**Likes Count**: es una feature bastante trivial pero se alinea con la visión que tenemos para el futuro de la aplicación, jugando con los modelos sociales de los humanos ver que un voluntariado fue likeado por muchas personas nos inclina a likearlo también, y ver que en general la aplicación tiene mucha interacción de otros usuarios también nos inclina a querer ser parte. Además abre la posibilidad de tener un ordenamiento por likes y que los organizadores usen sus otras plataformas para distribuir la nuestra en función de conseguir más likes y por ende más visibilidad en nuestra aplicación.
El ordenamiento por likes es lógicamente muy básico y probablemente se requiera una query más compleja que requiera algún time frame, por ejemplo un ordenamiento según la tasa de likes por día.

### Métricas

En base a nuestra visión del futuro de la aplicación y hacia dónde la queremos dirigir planteamos las features previas, pero nuestra imaginación no sirve de nada si no está anclada en la realidad, por esto definimos métricas que nos permitan validar nuestros planteos y la efectividad de nuestras features.

**Detalles Vistos pre postulación**: esta métrica registra ante el evento de una postulación cuántos detalles vio el usuario, esta métrica está relacionada con el botón de sorteo, consideramos que si la feature está siendo efectiva y el usuario aprovecha las facilidades de ordenamiento va a ser capaz de encontrar un voluntariado que satisfaga sus requisitos con mayor facilidad. Consideramos que a medida que se abra la aplicación a una versión más social y no tan funcional esta métrica empezará a reflejar la aparición de un nuevo perfil de usuario con muchas más interacciones pero menores postulaciones, eventualmente aumentando la métrica.

**Likes otorgados**: claramente esta métrica está estrechamente relacionada a la feature del like count, queremos medir si el hecho de ver el número de cuántos otros humanos les pareció interesante el voluntariado lo obliga subconscientemente a likear más. También sería interesante analizarla en relación a otras futuras features más grandes, por ejemplo ante un revamp de la visual de la aplicación donde el feed pase a ser más instagram-ish habilitando una medición del engagement.

**Días de gracia en caso de abandono**: esta métrica dictamina cuántos días antes de la fecha de inicio del voluntariado es que un usuario la abandona, esta métrica se enfoca en las organizaciones que publican voluntariados, una parte necesaria y hasta ahora ignorada en nuestro análisis de la aplicación. Entendemos que la situación más dolorosa para una de estas organizaciones es la de los abandonos con poca antelación o la ausencia injustificada, aun más considerando el foco que hay en los cupos de cada uno de estos voluntariados. Con esta métrica buscamos gestionar este patrón de uso e idealmente agregar futuras features para mitigarlo, por ejemplo mandando mails de recordatorio al usuario cuando el evento se aproxima, tal vez incluir algún ranking o métrica de los usuarios que aumente según los voluntariados a los que uno asiste pero que se reduzca en caso de abandonos o ausencia, jugando un poco con la pata de **GAMIFICATION!**.

## How to Run

1. Instalar las dependencias y asegurarse de usar la versión correcta de Flutter:

    ```bash
    fvm install
    fvm flutter pub get
    ```

2. Descargar el archivo APK de [Google Drive](https://drive.google.com/drive/folders/12xucFu4HZSAOvB26NkTOLRpiJMANaS0y?usp=sharing) o buildearlo directamente desde el directorio raíz del proyecto:

    ```bash
    fvm flutter build apk --release
    ```

3. Instalar ADB con el siguiente comando:

    ```bash
    sudo apt install google-android-platform-tools-installer
    ```

4. Conectar celular Android físico o emular uno. Verificar que sea detectado:

    ```bash
    adb devices
    ```

5. Para poder verificar el funcionamiento de los deep links, debemos modificar los hosts del dispositivo.

    Los hosts del dispositivo se encuentran en `/etc/hosts`. Para modificarlos, primero debemos obtener acceso root ya que son archivos protegidos del sistema. Para esto, se puede usar ADB:

    ```bash
    adb root
    adb remount
    adb pull /etc/hosts ./hosts
    ```

    Luego, editar el archivo `hosts` y agregar la siguiente línea:

    ```bash
    10.2.2.0 sermanos.app
    ```

    Finalmente, subir el archivo modificado al dispositivo:

    ```bash
    adb push ./hosts /etc/hosts
    ```

    Verificar que el archivo `hosts` se haya modificado correctamente:

    ```bash
    adb shell cat /etc/hosts
    ```

6. Instalar el APK:

    ```bash
    adb install build/app/outputs/flutter-apk/app-release.apk
    ```

> Nota: El path del APK es válido si se buildeó localmente. En caso de descargarlo, ajustar el path según ubicación.
> Si usás un IDE como VSCode o Android Studio, asegurate de configurar el path de Flutter a través de FVM (`.fvm/flutter_sdk`) para que coincida con la versión definida en `.fvmrc`. Esto evita inconsistencias al buildear o testear.

### Run in Debug Mode (Emulador o Simulador)

Si no tenés un dispositivo físico, podés usar un emulador o simulador para correr la app en modo debug.

1. Abrí tu IDE (VSCode o Android Studio)
2. Asegurate de tener configurado el path de Flutter con FVM (VSCode lo detecta automáticamente si tenés el plugin instalado)
3. Lanzá el emulador o simulador

Ejecutá:

```bash
fvm flutter emulators
fvm flutter emulators --launch <nombre_del_emulador>
fvm flutter run
```

> También podés correr `fvm flutter run` directamente y Flutter detectará dispositivos disponibles, incluyendo emuladores abiertos.

## Accepting a Volunteer

1. Ir a la consola de firebase
2. Ir a la colección `usuarios`
3. Buscar el usuario que se desea aceptar
4. Ir a su campo `voluntariadoAceptado` y poner el booleano en `true`
5. Luego buscar el voluntariado correspondiente y restar 1 al campo `vacantes`

---

## Unit Testing & Golden Tests

Se desarrollaron tests unitarios para nuestros controllers (son los que contienen la lógica de negocio en nuestra aplicación) y los servicios, aunque estos últimos, debido a su simplicidad y pocas dependencias externas, no son tan críticos y podrían ser obviados.
También se incluyeron golden tests, los cuales no aportan mucho valor. Sin embargo, si utilizaran como valor de verdad el *design system*, estos podrían pasar a ser una pieza fundamental del desarrollo.

Se puede testear la aplicación ejecutando el siguiente comando en el directorio del proyecto:

```bash
flutter test --update-goldens
```

## A/B Testing

El A/B Testing es la confluencia de las ideas que venimos reiterando a lo largo de las secciones previas: temáticas como la *gamification*, el aumento del *engagement* y la expansión de la aplicación por fuera del propósito funcional de inscripción a voluntariados.
Por esto, el A/B Testing busca analizar el impacto de las *features* que planteamos en esos ejes centrales. Para poder hacer este análisis crítico, se requiere que la información sea recaudada por medio de las métricas.
A continuación, se detallan algunos de los tests que ideamos:

### Test 1

Generando una variante donde los usuarios puedan ver el *likes count*, podemos analizar si hay una mejora en la cantidad de *likes* que los usuarios otorgan.
La hipótesis y soporte para esta idea es el hecho de que los humanos suelen actuar en masa. Por ende, si un voluntariado está *likeado* por muchas personas, el usuario se ve más inclinado a *likear* si es que le genera algún agrado.
También genera una sensación de comunidad y actividad. La aplicación, en su estado más puro, la hace parecer un *marketplace* de voluntariados, mientras que con esta adición se empieza a perfilar la idea de una comunidad de voluntarios que aportan con algo que no es su presencia física.
También es interesante destacar que se puede generar el efecto adverso: si un usuario ve que los voluntariados tienen muy pocos *likes*, puede empezar a ver la aplicación como menos confiable y sentirse menos inclinado a participar.

### Test 2

Otro experimento que se puede desarrollar se basaría en generar una variante con el botón de ordenamiento, y analizar la métrica que cuantifica cuántos voluntariados se vieron antes de inscribirse en uno de ellos, así como la cantidad de *likes*.
En este caso, lo que hipotetizamos es que se van a desarrollar dos tipos de usuarios distintos: uno que prefiere el ordenamiento por cercanía, ya que su objetivo es directamente inscribirse en un voluntariado sin más distracciones. Este tendría pocos *likes* otorgados y pocos voluntariados vistos hasta su postulación.
Luego tendríamos otro grupo de usuarios que preferiría ordenar por frescura, ya que está más interesado en la actualidad y lo que está sucediendo dinámicamente. Este usuario entiende la página de voluntariados como un *feed* y no como un *marketplace*. Este usuario desarrollaría un patrón de uso más parecido al de las redes sociales, con mayores interacciones, otorgaría muchos más *likes* y leería muchos detalles de voluntariados antes de postularse, o tal vez nunca lo haga.

## Decisions

### All my homies hate grouping by features

Fuimos por un agrupamiento por features, si bien no es una decisión crítica debido al tamaño del proyecto, incluso a esta escala se pueden notar algunos defectos en el modelo. En aplicaciones complejas la interconexión de funcionalidades es alta, o sea que una interacción en particular provoca efectos en múltiples entidades, idealmente estas entidades están todas encerradas bajo la misma feature pero este no suele ser el caso.
Un ejemplo que sufre incluso Ser Manos, es el manejo del usuario, múltiples métodos en distintas features necesitan acceder a un servicio que otorgue información sobre el usuario entonces termina siendo imposible crear un servicio que sea *aislado* por feature. Esto genera que distintos controllers salten el aislamiento por feature rompiendo la idea del modelo.
Además, existen otros servicios como la remote config y analytics que también deben ser utilizados sin la condición de aislamiento y por esto tenemos una carpeta de servicios llamada `infrastructure`.
Considerando el caso de las entidades que no se pueden recluir a una sola feature, y los servicios que son requeridos por toda la aplicación nos termina pareciendo un poco inútil usar el modelo de agrupamiento por feature si nos vemos obligados a romperlo. Para peor, estas ocurrencias no son excepcionales ni particulares de nuestra aplicación que termina siendo bastante simple.

### I know the rules so I can break them

Internamente cada agrupamiento por feature cuenta con 3 carpetas, `screens`, `controllers` y `services` entre estas 3 carpetas se respeta una subarquitectura de capas donde las screens realizan llamados a los `controllers` que luego hacen llamados a los `services`. Aunque estas denominaciones son abusos de notaciones cuando tenemos en cuenta su contenido, los `controllers` no son simples facades y terminan incluyendo tanto estado como lógica de negocios, por otro lado los `services` solo contienen el acceso a la base de datos. Entonces:

\$\text{Controller Nuestro} = \text{Controller Clásico} + \text{Servicio Clásico} + \text{Estado}\$

\$\text{Service Nuestro} = \text{DAO Clásico}\$

Esta decisión se basa en la reducción de bloat en la codebase, un gran porcentaje de los métodos de los controllers ya son simple pasamanos a los servicios (porque hay poca lógica de negocio), e incluir una nueva capa completa solo hubiera agudizado esta propiedad indeseada.

### Functional Providers VS Class-Based Providers

Esta fue una decisión difícil, la granularidad de los Functional Providers donde cada método de un controller/servicio es un provider, es muy placentera en cuanto a manejo de memoria e instanciación, pero termina facilitando incumplimiento de la arquitectura y siendo más difícil de mantener por momentos. Estas desventajas se podrían mitigar fácilmente con algunas herramientas externas pero priorizamos la simplicidad y familiaridad del equipo con estructuras similares a las de Spring.
Por esto, terminamos eligiendo la estructura de Class-Based Providers, donde se crea una clase con métodos de instancia y luego por medio de un provider se disponibiliza. A este se le suman los StateNotifierProviders que fue nuestra forma predilecta de manejar el estado, donde estos providers inyectaban la instancia del controlador y hacían uso de sus métodos para acceder a la capa de servicios.

### RIP DTOs

De nuevo, vuelve a la idea de no bloatear el código innecesariamente, es un lujo que nos podemos dar debido a que tenemos acceso directo a la DB y las facilidades que otorga firebase para su manejo, además de que no hay funcionalidades que requieran una reinterpretación del modelo de usuario provisto por el backend.

---
