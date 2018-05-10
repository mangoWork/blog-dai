###　JWT中的python开发

### demo

*  在执行如下代码：

  ```python
  payload = {
          'iss': 'jeff',
          'exp': utc_timestamp() + 15,
          'claim': 'insanity'
      }

      secret = 'secret'
      jwt_message = jwt.encode(payload, secret)
  ```

* 当执行jwt.encode(...)的时候，签名默认的算法是HS256, 头部默认为空，如果传递的playload如果不为``Mapping``类型，则会抛出``TypeError``,代码如下：

  ```python
      def encode(self, payload, key, algorithm='HS256', headers=None,
                 json_encoder=None):
          # Check that we get a mapping
          if not isinstance(payload, Mapping):
              raise TypeError('Expecting a mapping object, as JWT only supports '
                              'JSON objects as payloads.')

  ```

*  接着再比较荷载中的时间戳是否是``datetime``类型，