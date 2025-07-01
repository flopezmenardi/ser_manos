
# Ser Manos

[Image!](https://firebasestorage.googleapis.com/v0/b/ser-manos-d9350.firebasestorage.app/o/Screenshot%20from%202025-05-29%2011-35-39.png?alt=media&token=47ace2b4-2daf-4b5c-acb5-46c33823f2f1)

## Contributors

- Felix Lopez Menardi
- Joaquin Girod
- Manuel Dithurbide

## Stack Tecnológico

Para el desarrollo de la aplicación se eligió un stack tecnológico simple, coherente y eficiente, priorizando un bajo costo de mantenimiento, una curva de aprendizaje accesible y un fuerte soporte de la comunidad. Las decisiones tomadas siguen en gran medida las mejores prácticas y recomendaciones de la comunidad Flutter, así como de los docentes involucrados en el proyecto.

### Framework principal

- **Flutter**
  Framework de desarrollo multiplataforma, permite compartir la mayor parte del código entre iOS y Android, acelerando el ciclo de desarrollo y reduciendo los costos de mantenimiento.

### Gestión de navegación

- **go\_router (`^15.1.3`)**
  Se seleccionó `go_router` por su simplicidad y bajo nivel de complejidad en comparación con otros enrutadores. Su integración directa con Flutter y su soporte oficial lo convierten en una solución robusta y escalable para el manejo de rutas.

### Arquitectura y manejo de estado

- **Riverpod (`flutter_riverpod: ^2.5.1`, `hooks_riverpod: ^2.4.0`, `flutter_hooks: ^0.21.2`)**
  Riverpod fue elegido como gestor de estado por su flexibilidad, su enfoque declarativo y su fuerte integración con los principios de programación reactiva. Además, permite una mayor testabilidad y separación de responsabilidades dentro de la aplicación.

### Backend & Servicios

- **Firebase**
  Se utilizó Firebase como backend-as-a-service (BaaS), lo que permitió acelerar el desarrollo y simplificar la gestión de infraestructura:
  - `firebase_core: ^3.13.0`
  - `cloud_firestore: ^5.6.7` (Base de datos NoSQL en tiempo real)
  - `firebase_auth: ^5.5.3` (Autenticación de usuarios)
  - `firebase_analytics: ^11.4.6` (Analítica de uso)
  - `firebase_crashlytics: ^4.3.6` (Reporte de errores)
  - `firebase_remote_config: ^5.4.5` (Configuración remota)
  - `firebase_storage: ^12.1.0` (Almacenamiento de archivos)

### Herramientas complementarias

- **Geolocalización y mapas:**
  `geolocator: ^14.0.1` (acceso a la ubicación del dispositivo).
- **Compatibilidad con URLs y recursos externos:**
  `url_launcher: ^6.2.4` (apertura de links externos), `share_plus: ^11.0.0` (compartir contenido).
- **Captura y carga de imágenes:**
  `image_picker: ^1.1.0` (selección de imágenes de la galería o cámara).
- **Manejo de permisos:**
  `permission_handler: ^12.0.0+1` (gestión de permisos en runtime).
- **Formularios avanzados y validación:**
  `flutter_form_builder: ^9.1.1`, `form_builder_validators: ^11.1.2`.
- **Internacionalización:**
  `intl: ^0.19.0` (todavia no implementamos i18n).
- **Renderizado de markdown:**
  `flutter_markdown: ^0.7.7+1`.
- **HTTP Requests:**
  `http: ^1.1.0`.
- **Manejo de almacenamiento local**
  `path_provider: ^2.1.5`.

### Testing y desarrollo

- **Mockito (`^5.4.4`) y Fake Cloud Firestore (`^3.1.0`):**
  Herramientas utilizadas para la creación de mocks y pruebas unitarias.
- **build\_runner (`^2.4.8`):**
  Generación automática de código durante el desarrollo y testing.
- **flutter\_launcher\_icons (`^0.13.1`):**
  Generación de íconos de aplicación para múltiples plataformas.

## Metrics & Feature Flagging

Para la activación de las features se puede ir a la remote config y alterar los valores de las variables `show_like_counter` y `show_proximity_button`.
Intentamos mantener estos dos puntos lo más cercanos posibles y que se retroalimenten, generando una especie de narrativa a partir de la feature y medir qué tan correcta es nuestra imaginación con una métrica (básicamente hipotetizar y verificar). Al mismo tiempo no queríamos que la métrica dependiera únicamente de la feature, o sea que si la feature está desactivada la métrica recaude información de todas maneras, así que hilamos fino en busca de métricas que fueran globales pero útiles para las nuevas features.

### Features

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

1. Descargar archivo APK de [Google Drive](https://drive.google.com/drive/folders/12xucFu4HZSAOvB26NkTOLRpiJMANaS0y?usp=sharing) o buildeando el APK directamente desde directorio raíz del proyecto con el siguiente comando:

    ```bash
    flutter build apk --release
    ```

2. Instalar adb con el siguiente comando:

    ```bash
    sudo apt install google-android-platform-tools-installer
    ```

3. Conectar celular android físico o emular uno

4. Correr el siguiente comando:

  ```bash
  adb install build/app/outputs/flutter-apk/app-release.apk
  ```

Donde el path es correcto si se buildeó el APK utilizando el comando en el paso 1, y si no se debe colocar el path donde se guardó luego de descargarlo de Google Drive

## Accepting a Volunteer

1. Ir a la consola de firebase
2. Ir a la colección `usuarios`
3. Buscar el usuario que se desea aceptar
4. Ir a su campo `voluntariadoAceptado` y poner el booleano en `true`
5. Luego buscar el voluntariado correspondiente y restar 1 al campo `vacantes`

## Unit Testing & Golden Tests

Se desarrollaron tests unitarios para nuestros controllers (son los que contienen la logica de negocio en nuestra aplicacion) y los servicios, aunque los segundos, debido a la simplicidad y pocas dependencias externas, no son tan criticos y podrian ser obviados.
Tambien se incluyeron golden-tests, los cuales no aportan mucho valor, si en cambio utilizaron como valor de verdad el design system estos podrian pasar a ser una pieza fundamental del desarrollo.

Se puede testear la aplicacion ejecutando el siguiente comando en el directorio del proyecto:

```bash
flutter test --update-goldens
```

## A/B Testing

El A/B Testing es la confluencia de las ideas que venimos reiterando a lo largo de las secciones previas, tematicas como la gamification, el aumento del engagement y la expansion de la aplicacion por fuera del proposito funcional de inscripcion a voluntariados.
Por esto, el A/B testing busca analizar el impacto de las features que planteamos en esos ejes centrales y para poder hacer este analisis critico se requiere informacion se recaudada por medio de las metricas.
A continuacion se detallan algunos de los tests que ideamos:

### Test 1

Generando una variante donde los usuarios puedan ver el likes count, podemos analizar si hay una mejora en la cantidad de likes que los usuarios otorgan.
La hipotesis y soporte para esta idea es el hecho de que los humanos suelen actuar en masa, por ende si un voluntariado esta likeado por muchas personas, el usuario se ve mas inclinado a likear si es que le genera algun agrado. Tambien genera una sensacion de comunidad y actividad, la aplicacion en su estado mas puro la hace parecer un marketplace de voluntariados, mientras que con esta adicion se empieza a perfilar la idea de una comunidad de voluntarios que aportan con algo que no es su presencia fisica.
Tambien es interesante destacar que se puede generar el efecto adverso, si un usuario ve que los voluntariados tienen muy pocos likes, puede empezar a ver la aplicacion como menos confiable y sentirse menos inclinado a participar.

### Test 2

Otra experimento que se puede desarrollar se basaria en generar una variante con el boton de ordenamiento, y analizar la metrica que cuantifica cuantos voluntariados se vieron antes de que inscribirse en uno de ellos al igual que la cantidad de likes.
En este caso lo que hipotetizamos es que se van a desarrollar dos tipos de usuarios distintos, uno que prefiere el ordenamiento por cercania ya que su objetivo es directamente inscribirse en un voluntariado sin mas distracciones, este tendria pocos likes otorgados y pocos voluntariados vistos hasta su postulacion. Luego tendriamos otro grupo de voluntariados que preferiria ordenar por frescura, ya que esta mas interesado en la actualidad y lo que esta sucediendo dinamicamente, este usuario entiende la pagina de voluntariados como un feed y no como un marketplace. Este usuario que desarrollaria un patron de uso mas parecido al de las redes sociales con mayores interacciones, otorgaria muchos mas likes y leeria muchos detalles de voluntariados antes de postularse o tal vez nunca lo haga.

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
