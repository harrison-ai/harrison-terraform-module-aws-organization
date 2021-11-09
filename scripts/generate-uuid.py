import uuid


def main():
    print('---')
    for n in range(5):
        print(str(uuid.uuid4()))
    print('---')


if __name__ == "__main__":
    main()
