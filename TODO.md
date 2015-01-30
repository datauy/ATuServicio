## Layout
- [X] calculate averages by provider
- [X] calculate summary info by state
- [X] routes with provider_id
- [X] add rest of CSV's
- [X] add selects
- [ ] show all the data necessary:
  - [X] Home
  - [ ] Comparison
- [ ] migrate frontend

## Data
- [ ] Fix `rrhh.csv` and import it to the DB
- [ ] fix rake import is making up precision??

## Functionality
- [ ] Select changes URL in Home
- [ ] Link to order by column
- [X] Accept `comparar/` with no providers
- [ ] Select changes URL in Comparison
- [ ] Remove URL changes URL in Comparison

## Other
- [ ] calculate stats
- [ ] use pretty names for ids in routes
- [X] use alias 'comparar for compare route (just changed the name in Spanish)

## Performance
- [ ] use procfile (avoid webrick)
- [ ] Use JS & ajax when possible
- [ ] cache averages and summary info

## Data
- [ ] `sedes.csv` correct state `San Jose` with `San José`
- [ ] `rrhh.csv` correct format

## Wish List
- [ ] uncomment 'ruby' definition in Gemfile
- [ ] separate metadata from metadata for migrations
- [ ] call methods/modules from migrations
- [ ] use seeds.rb instead of `db:import` rake task


