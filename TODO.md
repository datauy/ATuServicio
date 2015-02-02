## Layout
- [X] calculate averages by provider
- [X] calculate summary info by state
- [X] routes with provider_id
- [X] add rest of CSV's
- [X] add selects
- [X] show all the data necessary:
  - [X] Home
  - [X] Comparison
- [X] migrate frontend

## Data
- [ ] Fix `rrhh.csv` and import it to the DB
- [X] fix rake import is making up precision??

## Functionality
- [X] Select changes URL in Home
- [ ] Link to order by column
- [X] Accept `comparar/` with no providers
- [X] Select changes URL in Comparison
- [S] Remove URL changes URL in Comparison

## Other
- [ ] calculate stats
- [ ] use pretty names for ids in routes
- [X] use alias 'comparar for compare route (just changed the name in Spanish)

## Performance
- [ ] use procfile (avoid webrick)
- [ ] cache averages and summary info
- [ ] Use JS & ajax when possible
- [ ] Generate state table with id's, so there's no N+1

## Data
- [ ] `sedes.csv` correct state `San Jose` with `San José`
- [ ] `rrhh.csv` correct format

## Wish List
- [ ] uncomment 'ruby' definition in Gemfile
- [ ] separate metadata from metadata for migrations
- [ ] call methods/modules from migrations
- [ ] use seeds.rb instead of `db:import` rake task
eliminar state_id de provider

