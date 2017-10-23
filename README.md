# imagecr

Image.cr is a shard to quickly and performantly identify an image type and basic
attributes of the image.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  imagecr:
    github: taylorfinnell/imagecr
```

## Supported Image Types

- TIFF
- GIF
- BMP
- PNG
- PSD

## Usage

```crystal
require "imagecr"
```

Open from a URL.

```
image = Imagecr.open("http://someserver.com/test.png")
image.type   # => "png"
image.width  # => 100
image.height # => 100
```

Open from a local file.

```
image = Imagecr.open("~/Downloads/test.png")
image.type   # => "png"
image.width  # => 100
image.height # => 100
```
