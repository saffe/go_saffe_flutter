# GoSaffeCapture Flutter

## Instalação

Para utilizar o GoSaffeCapture em seu projeto Flutter, você precisa adicionar a dependência ao seu arquivo `pubspec.yaml`:

```yaml
dependencies:
  go_saffe_flutter: ^1.0.0
```

Após adicionar a dependência, execute `flutter pub get` para instalar o pacote.

## Uso

Para utilizar o GoSaffeCapture em seu aplicativo, siga estas etapas:

1. Importe o pacote `go_saffe_flutter/go_saffe_flutter.dart`.

```dart
import 'package:go_saffe_flutter/go_saffe_flutter.dart';
```

2. Crie uma instância de GoSaffeCapture com os parâmetros necessários, incluindo a chave de API, identificador do usuário, tipo e ID de ponta a ponta. Além disso, defina as funções de callback `onFinish` e `onClose` para lidar com os eventos correspondentes recebidos do WebView.

```dart
GoSaffeCapture(
  apiKey: 'sua_api_key',
  identifier: 'identificador_do_usuario',
  type: 'tipo',
  endToEndId: 'end_to_end_id',
  onFinish: () {
    // Faça algo quando o evento finish for recebido
    print('Evento finish recebido');
  },
  onClose: () {
    // Faça algo quando o evento close for recebido
    print('Evento close recebido');
  },
),
```

3. Adicione o widget GoSaffeCapture onde você deseja que ele seja exibido em sua interface de usuário.

```dart
Scaffold(
  appBar: AppBar(
    title: Text('Exemplo de GoSaffeCapture'),
  ),
  body: Center(
    child: GoSaffeCapture(
      apiKey: 'sua_api_key',
      identifier: 'identificador_do_usuario',
      type: 'tipo',
      endToEndId: 'end_to_end_id',
      onFinish: () {
        // Faça algo quando o evento finish for recebido
        print('Evento finish recebido');
      },
      onClose: () {
        // Faça algo quando o evento close for recebido
        print('Evento close recebido');
      },
    ),
  ),
),
```

Certifique-se de substituir `'sua_api_key'`, `'identificador_do_usuario'`, `'tipo'` e `'end_to_end_id'` pelos valores reais necessários.

## Suporte

Se você tiver alguma dúvida ou encontrar algum problema, sinta-se à vontade para abrir uma [issue](https://github.com/saffe/go_saffe_flutter/issues) neste repositório.
