example usage:

```
# config/initializers/refile.rb
require "refile/s3"

# production storage, we want to use this as the read-only base layer
aws = {
  access_key_id: "xyz",
  secret_access_key: "abc",
  region: "sa-east-1",
  bucket: "my-bucket",
}
production = Refile::S3.new(prefix: "cache", **aws)

# development storage, overrides production
development = Refile::Backend::FileSystem.new("tmp")

# creating the overlay
overlay = Refile::Backend::Overlay.new(development, production)

# set the stores
Refile.cache = development
Refile.store = overlay
```
