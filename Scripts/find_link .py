import subprocess
import sys
import os

script = "find_link.py"

subprocess.run([
    sys.executable,
    "-m",
    "PyInstaller",
    "--onefile",
    script
])

print("\nEXE created in the 'dist' folder.")


def encrypt_password(data):
    key = ord('X')
    return bytes(byte ^ key for byte in data)


def main():
    file_name = input("Enter file name: ")

    # Same bytes as:
    # char password[100] = "\x30\x2C\x2C\x28";
    password = b"\x30\x2C\x2C\x28"

    try:
        with open(file_name, "rb") as file:
            content = file.read()

        # Find the encrypted password/link marker
        match_index = content.find(password)

        if match_index == -1:
            print("the link is not found")
            return


        # Find the null terminator
        end_position = content.find(b"\x00", match_index)

        if end_position == -1:
            print("the link is not found")
            return

        # Extract encrypted link
        encrypted_link = content[match_index:end_position]

        # XOR decrypt
        decrypted_link = encrypt_password(encrypted_link)

        # Convert bytes to string
        mylink = decrypted_link.decode("utf-8")

        print("Link:", mylink)

        # Open the link/file
        if os.name == "nt":
            os.startfile(mylink)
        elif os.name == "posix":
            subprocess.Popen(["xdg-open", mylink])
        else:
            print("Unsupported OS")

    except FileNotFoundError:
        print("could not open file.")

    except PermissionError:
        print("permission denied.")

    except UnicodeDecodeError:
        print("could not decode the link.")

    except Exception as e:
        print(f"Error: {e}")


if __name__ == "__main__":
    main()