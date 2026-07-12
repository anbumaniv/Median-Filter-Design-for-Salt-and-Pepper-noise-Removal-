import os
import cv2
import numpy as np

input_folder = r"inputImages"
output_folder = r"NoisyImages"

os.makedirs(output_folder, exist_ok=True)

extensions = (".jpg", ".jpeg", ".png", ".bmp", ".tif", ".tiff")

def add_salt_pepper_noise(image, amount):

    noisy = image.copy()


    h, w = noisy.shape[:2]
    total_pixels = h * w

    num_noise = int(total_pixels * amount)


    num_salt = num_noise // 2
    num_pepper = num_noise - num_salt

    coords = (
        np.random.randint(0, h, num_salt),
        np.random.randint(0, w, num_salt),
    )
    noisy[coords] = 255


    coords = (
        np.random.randint(0, h, num_pepper),
        np.random.randint(0, w, num_pepper),
    )
    noisy[coords] = 0

    return noisy


def add_random_impulse_noise(image, amount):

    noisy = image.copy()

    h, w = noisy.shape
    total_pixels = h * w

    num_noise = int(total_pixels * amount)

    rows = np.random.randint(0, h, num_noise)
    cols = np.random.randint(0, w, num_noise)

    random_values = np.random.randint(0, 256, num_noise, dtype=np.uint8)

    noisy[rows, cols] = random_values

    return noisy

for filename in os.listdir(input_folder):

    if not filename.lower().endswith(extensions):
        continue

    filepath = os.path.join(input_folder, filename)

    image = cv2.imread(filepath, cv2.IMREAD_GRAYSCALE)

    if image is None:
        continue

    basename, ext = os.path.splitext(filename)

    for total_noise in range(5, 100, 5):

        fn = total_noise * 0.8
        rn = total_noise * 0.2

        fn_fraction = fn / 100.0
        rn_fraction = rn / 100.0

        noisy = add_salt_pepper_noise(image, fn_fraction)

        noisy = add_random_impulse_noise(noisy, rn_fraction)

        new_name = f"{basename}_FN{round(fn)}_RN{round(rn)}{ext}"

        cv2.imwrite(
            os.path.join(output_folder, new_name),
            noisy
        )

print("Finished!")
print("Output Folder:", output_folder)