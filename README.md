# Brújula Quest · Sociales

Aplicación educativa Flutter de GeoExplorer.

## Compilaciones iOS

El workflow **Compilar iOS** se ejecuta al actualizar `main`/`master` o desde
GitHub Actions. Siempre publica `BrujulaQuest-iOS-Simulator.zip`, que contiene
la app para el simulador de iOS.

Para generar una IPA instalable en dispositivos, configura estos secretos del
repositorio en **Settings → Secrets and variables → Actions**:

- `IOS_CERTIFICATE_BASE64`: certificado de distribución Apple `.p12` codificado
  en Base64, incluyendo su clave privada.
- `IOS_CERTIFICATE_PASSWORD`: contraseña del archivo `.p12`.
- `IOS_PROVISIONING_PROFILE_BASE64`: perfil Ad Hoc para el Bundle ID
  `es.uva.smov.smov`, codificado en Base64. Incluye los dispositivos registrados
  en los que se instalará la app.
- `IOS_TEAM_ID`: identificador del equipo de Apple Developer.

Con los cuatro secretos configurados, el workflow también publica
`BrujulaQuest-iOS-IPA`. Sin ellos, solo se compila la versión de simulador.
