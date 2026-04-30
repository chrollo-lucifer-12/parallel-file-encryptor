flowchart LR

    user((user))
    fed[file encryptor / decryptor]
    io[io]
    pm[process management]
    queue[(queue)]
    child[spins up a child process]
    ed((encrypt / decrypt))

    user --> fed

    fed -->|open / write / read| io
    fed -->|submits a task| pm

    pm -->|submits to the queue| queue
    queue -->|consumes| pm

    child -->|signal from child| pm

    ed <-->|encrypt / decrypt| child
