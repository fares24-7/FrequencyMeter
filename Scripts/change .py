import subprocess
import sys

script = "change.py"

subprocess.run([
    sys.executable,
    "-m",
    "PyInstaller",
    "--onefile",
    script
])

print("\nEXE created in the 'dist' folder.")

def encrypt_password(password):
    key = ord('X')
    return ''.join(chr(ord(c) ^ key) for c in password)

def find_pattern(file, pattern_bytes):
    file.seek(0)
    content = file.read()
    
    pattern = pattern_bytes.encode('utf-8')
    pos = content.find(pattern)
    
    if pos != -1:
        return pos + len(pattern)
    return -1

def main():
    file_name = input("Enter file name: ")
    new_password = input("Enter new password: ")
    
    encrypted_password = encrypt_password(new_password)
    
    try:
        with open(file_name, "rb+") as file:
            old_password = "(9++"
            
            patch_position = find_pattern(file, old_password)
            
            if patch_position == -1:
                print("old password is different")
                return
            
            file.seek(patch_position)
            file.write(encrypted_password.encode('utf-8'))
            file.write(b'\0')
            
            print("password changed successfully.")
            
    except FileNotFoundError:
        print("could not open file.")
    except PermissionError:
        print("permission denied.")
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    main()