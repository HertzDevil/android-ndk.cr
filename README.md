# android-ndk.cr

Crystal bindings for the Android Native Development Kit (NDK), manually written
based on `$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/<host>/sysroot/usr/include`

Partially inspired by https://github.com/ysbaddaden/android.cr and
https://github.com/ysbaddaden/java.cr (JNI bindings are taken from there)

Extremely incomplete! Only has enough functionality for
https://github.com/HertzDevil/crystal-android-hello-world

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     android_ndk:
       github: HertzDevil/android-ndk.cr
   ```

2. Run `shards install`

## Usage

```crystal
require "android_ndk"
```

TODO: Write usage instructions here

## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/HertzDevil/android-ndk.cr/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Quinton Miller](https://github.com/HertzDevil) - creator and maintainer
