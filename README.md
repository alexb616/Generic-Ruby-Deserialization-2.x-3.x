# Generic-Ruby-Deserialization-Ruby-2.x-3.x
A simple Ruby deserialization payload generator tested across multiple Ruby versions using Docker. Generates both Base64 and raw Marshal payloads for research and security testing.

This script (`serialize_me.rb`) generates Ruby deserialization payloads (Base64 and raw Marshal). Run it inside Docker to test payloads against different Ruby versions without installing Ruby locally— pass the command to embed as the script argument.

You can run the script for a single Ruby version or loop through many versions to compare outputs.

Run with a specific Ruby version

```bash
docker run --rm \
  -v "$PWD":/work -w /work \
  ruby:2.6 \
  ruby serialize_me.rb 'whoami' 2>/dev/null
```

Replace 2.6 with the Ruby version you want and 'whoami' with the command to embed.

Run across multiple Ruby versions

```
for i in $(seq -f 2.%g 0 7) 3.0; do
  echo "ruby:${i}"
  docker run --rm -v "$PWD":/work -w /work ruby:${i} \
    ruby serialize_me.rb 'whoami' 2>/dev/null
  echo "-----------------------"
done
```

Reference: https://devcraft.io/2021/01/07/universal-deserialisation-gadget-for-ruby-2-x-3-x.html
