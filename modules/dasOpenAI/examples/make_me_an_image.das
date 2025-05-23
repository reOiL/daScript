options gen2
options persistent_heap = true
options gc

require openai/openai
require daslib/base64
require fio
require daslib/strings_boost

def get_test_file_name(name : string) {
    let test_dir = "{get_das_root()}/modules/dasOpenAI/tests"
    return "{test_dir}/{name}"
}

def get_temp_file_name(name : string) {
    let temp_dir = "{get_das_root()}/temp"
    mkdir(temp_dir)
    return "{temp_dir}/{name}"
}

[export]
def main {
    if (!openai_key_is_set()) {
        to_log(LOG_ERROR, "OpenAI key is not set. Please set the OPENAI_KEY environment variable.")
        return
    }
    if (true) {
        var inscope image <- openai_create_image(Image(
            prompt = "Cartoony. A large stone wall with a wooden door in the center. The door is made of oak and has a simple iron handle. Above the door, there is a small carving of a dragon chiseled into the stone wall.",
            n = 1,
            size = 512,
            response_format = "b64_json"    // url
        ))
        if (image |> is_valid) {
            if (image.data |> length == 1) {
                fopen(get_temp_file_name("image.png"), "wb") <| $(f) {
                    if (f != null) {
                        var inscope bytes : array<uint8>
                        let res = base64_decode(image.data[0].b64_json, bytes)
                        f |> fwrite(bytes)
                        to_log(LOG_INFO, "image completion written to \"{get_temp_file_name("image.png")}\"\n")
                    } else {
                        to_log(LOG_ERROR, "failed to open image file {get_temp_file_name("image.png")} for writing")
                    }
                }
            }
        } else {
            to_log(LOG_ERROR, "image completion failed\n{openai_get_last_error()}\n")
        }
    }
    if (true) {
        var inscope image <- openai_create_image_variation(ImageVariation(
            image = get_temp_file_name("image.png"),
            n = 1,
            size = 256,
            response_format = "b64_json"    // url
        ))
        if (image |> is_valid) {
            if (image.data |> length == 1) {
                fopen(get_temp_file_name("image_variation.png"), "wb") <| $(f) {
                    if (f != null) {
                        var inscope bytes : array<uint8>
                        let res = base64_decode(image.data[0].b64_json, bytes)
                        f |> fwrite(bytes)
                        to_log(LOG_INFO, "image variation written to \"{get_temp_file_name("image_variation.png")}\"\n")
                    } else {
                        to_log(LOG_INFO, "failed to open image file {get_temp_file_name("image_variation.png")} for writing")
                    }
                }
            } else {
                to_log(LOG_ERROR, "image variation data is empty\n{openai_get_last_error()}\n")
            }
        }
    }
}


