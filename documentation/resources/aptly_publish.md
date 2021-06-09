# `aptly_publish`

Publish, remove or update a repo or a snapshot

## Actions

- `create` - (default) Publish a repo or a snapshot
- `drop` - Drop a publication
- `update` - Update publication

## Properties

| Name            | Types   | Description                                     | Default         | Used with...     |
| --------------- | ------- | ----------------------------------------------- | --------------- | ---------------- |
| `publish_name`  | String  | Publication name                                | <resource_name> | all              |
| `type`          | String  | Publish type (snapshot or repo)                 | ''              | :create          |
| `component`     | String  | Component name to publish                       | []              | :create          |
| `distribution`  | String  | Distribution name to publish                    | ''              | :create          |
| `architectures` | Array   | Only mentioned architectures would be published | []              | :create          |
| `endpoint`      | String  | An optional endpoint reference                  | ''              | :create, :update |
| `prefix`        | String  | An optional prefix for publishing               | ''              | :create, :update |
| `timeout`       | Integer | Timeout in seconds                              | 3600            | all              |

Note: The "architectures" property will use the global configuration (settable via node['aptly']['architectures']) if you do not provide it for a particular repository here.

## Examples

```ruby
aptly_publish 'my_repo' do
  type 'repo'
  component %w(main contrib)
  prefix 'my_company'
end
```

```ruby
aptly_publish 'my_snapshot' do
  type 'snapshot'
  endpoint 's3'
  prefix 'snap'
  action :create
end
```

```ruby
aptly_publish 'my_snapshot' do
  prefix 'snap'
  action :update
end
```

```ruby
aptly_publish 'my_snapshot' do
  prefix 'snap'
  action :drop
end
```

### 'aptly_serve'

Serve an HTTP Service

#### Actions

- `run` - (default) Run the service

#### Properties

| Name     | Types             | Description                             | Default             | Used with... |
| -------- | ----------------- | --------------------------------------- | ------------------- | ------------ |
| `listen` | String            | Specify IP address about HTTP listening | '' (all interfaces) | :run         |
| `port`   | [Integer, String] | Publish type (snapshot or repo)         | 8080                | :run         |
| `user`   | String            | Run command as user                     | 'aptly'             | :run         |
| `group`  | String            | Run command as group                    | 'aptly'             | :run         |

#### Examples

```ruby
aptly_serve 'Serve Aptly HTTP Service' do
  port 8090
end
```

### 'aptly_api_serve'

Serve an API Service

#### Actions

- `run` - (default) Run the service

#### Properties

| Name      | Types             | Description                             | Default             | Used with... |
| --------- | ----------------- | --------------------------------------- | ------------------- | ------------ |
| `listen`  | String            | Specify IP address about HTTP listening | '' (all interfaces) | :run         |
| `port`    | [Integer, String] | Publish type (snapshot or repo)         | 8080                | :run         |
| `user`    | String            | Run command as user                     | 'aptly'             | :run         |
| `group`   | String            | Run command as group                    | 'aptly'             | :run         |
| `no_lock` | [true, false]     | Don’t lock the database                 | false               | :run         |

#### Examples

```ruby
aptly_api_serve 'Serve Aptly API Service' do
  port 8091
  no_lock true
end
```
