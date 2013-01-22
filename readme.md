Ed25519
-------

This is a portable implementation of [Ed25519](http://ed25519.cr.yp.to/) based
on the SUPERCOP "ref10" implementation. All code is in the public domain.

All code is pure ANSI C without any dependencies, except for the random seed
generation which uses standard OS cryptography APIs. If you wish to be
entirely portable define `ED25519_NO_SEED`. This does disable the
`ed25519_create_seed` function however you can use your own seeding function
if you wish.


Performance
-----------

On a machine with an Intel Q6600 @ 2.4GHz I got the following speeds (running on only one thread):

    Key generation:    280us
    Message signing:   280us
    Message verifying: 840us

The speeds on other machines may vary.


Usage
-----

Simply add all .c and .h files in the `src/` folder to your project and
include `ed25519.h` in any file you want to use the API. If you prefer to use
a shared library, only copy `ed25519.h` and define `ED25519_DLL` before
importing. A windows DLL is pre-built.

There are no defined types for seeds, signing keys, verifying keys or
signatures. Instead simple `unsigned char` buffers are used with the following
sizes:

```c
unsigned char seed[32];
unsigned char signature[64];
unsigned char verify_key[32];
unsigned char signing_key[64];
```

API
---

```c
int ed25519_create_seed(unsigned char *seed);
```
Creates a 32 byte random seed in `seed` for key generation. `seed` must be a
writable 32 byte buffer. Returns 0 on success, and nonzero on failure.

```c
void ed25519_create_keypair(unsigned char *verify_key, unsigned char *sign_key, const unsigned char *seed);
```

Creates a new key pair from the given seed. `verify_key` must be a writable 32
byte buffer, `sign_key` must be a writable 64 byte buffer and `seed` must be a 32 byte buffer.

```c
void ed25519_sign(unsigned char *signature,
                 const unsigned char *message, size_t message_len,
                 const unsigned char *sign_key);
```

Creates a signature of the given message with `sign_key`. `signature` must be
a writable 64 byte buffer. `message` must have at least `message_len` bytes to
be read. `sign_key` must be a 64 byte signing key generated by
`ed25519_create_keypair`.

```c
int ed25519_verify(const unsigned char *signature,
                   const unsigned char *message, size_t message_len,
                   const unsigned char *verify_key);
```

Verifies the signature on the given message using verify_key. `signature` must be
a readable 64 byte buffer. `message` must have at least `message_len` bytes to
be read. `sign_key` must be a 32 byte verifying key generated by
`ed25519_create_keypair`. Returns 0 if the signature matches, 1 otherwise.

Example
-------
```c
unsigned char seed[32], sign_key[64], verify_key[32], signature[64];
const unsigned char message[] = "TEST MESSAGE";

/* create a random seed, and a keypair out of that seed */
if (ed25519_create_seed(seed)) {
    printf("error while generating seed\n");
    exit(1);
}

ed25519_create_keypair(verify_key, sign_key, seed);

/* create signature on the message with the sign key */
ed25519_sign(signature, message, strlen(message), sign_key);

/* verify the signature */
if (ed25519_verify(signature, message, strlen(message), verify_key)) {
    printf("invalid signature\n");
} else {
    printf("valid signature\n");
}
```