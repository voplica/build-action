#!/bin/bash

# Copyright 2025 Voplica LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Function to generate a 256-bit AES key
generate_aes_key() {
    local aes_key_file="$1"
    echo "Generating 256-bit AES key..."
    openssl rand -out "$aes_key_file" 32
    echo "AES key generated: $aes_key_file"
}

# Function to encrypt text using AES-256-CBC and encode it into base64
encrypt_aes() {
    local plaintext="$1"
    local aes_key_file="$2"
    local out_file="$3"

    echo "Encrypting plaintext using AES key..."
    echo -n "$plaintext" | openssl enc -aes-256-cbc -salt -pbkdf2 -in /dev/stdin -out "${out_file}.bin" -pass file:"$aes_key_file"
    base64 -w 0 "${out_file}.bin" > "$out_file"
    rm -f "${out_file}.bin"
}

# Function to encrypt the AES key with the RSA public key
encrypt_rsa() {
    local public_key="$1"
    local in_file_path="$2"
    local out_file_path="$3"

    echo "Encrypting AES key with RSA public key..."
    openssl pkeyutl -encrypt -in "$in_file_path" -pubin -inkey "$public_key" -out "${out_file_path}.bin"
    base64 -w 0 "${out_file_path}.bin" > "${out_file_path}"
    rm -f "${out_file_path}.bin"
}

# Main function to parse the arguments and call the appropriate function
main() {
    if [ $# -eq 0 ]; then
        echo "Usage: $0 <function> <arguments>"
        echo "Functions:"
        echo "  generate_aes_key --aes-key-file <path>"
        echo "  encrypt_aes --plaintext <text> --aes-key-file <path> --output-file-path <path>"
        echo "  encrypt_rsa --public-key <path> --in-file-path <path> --out-base64-file-path <path>"
        exit 1
    fi

    local command="$1"
    shift  # Remove the command from the arguments

    case "$command" in
        generate_aes_key)
            local aes_key_file
            while [[ $# -gt 0 ]]; do
                case "$1" in
                    --aes-key-file) aes_key_file="$2"; shift ;;
                    *) echo "Unknown option $1"; exit 1 ;;
                esac
                shift
            done
            generate_aes_key "$aes_key_file"
            ;;
        encrypt_aes)
            local plaintext aes_key_file output_file_path
            while [[ $# -gt 0 ]]; do
                case "$1" in
                    --plaintext) plaintext="$2"; shift ;;
                    --aes-key-file) aes_key_file="$2"; shift ;;
                    --output-file-path) output_file_path="$2"; shift ;;
                    *) echo "Unknown option $1"; exit 1 ;;
                esac
                shift
            done
            encrypt_aes "$plaintext" "$aes_key_file" "$output_file_path"
            ;;
        encrypt_rsa)
            local public_key in_file_path out_file_path
            while [[ $# -gt 0 ]]; do
                case "$1" in
                    --public-key) public_key="$2"; shift ;;
                    --in-file-path) in_file_path="$2"; shift ;;
                    --out-base64-file-path) out_file_path="$2"; shift ;;
                    *) echo "Unknown option $1"; exit 1 ;;
                esac
                shift
            done
            encrypt_rsa "$public_key" "$in_file_path" "$out_file_path"
            ;;
        *)
            echo "Unknown command: $command"
            exit 1
            ;;
    esac
}

# Run the main function
main "$@"
