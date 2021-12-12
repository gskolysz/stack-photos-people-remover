# stack-photos-people-remover

Remove people from image stack, automatically, using free software!
The script will align images and then calculate median to remove unwanted people from your lovely picture.

## Usage

The script requires docker engine to run, as it uses `imagemagick` and `hugin` to do all the magic.
Once you have docker engine installed:

1) Create a directory for your photo stack. Make sure they have `.jpg` extension.
2) Run `./remove-people.sh $your_directory_path`, where `$your_directory_path` is a directory from above.
3) Find `result.jpg` inside the directory. It's your final image!
