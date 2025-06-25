Start with

```bash
rails db:prepare
rails db:migrate db:seed
bin/dev
```

and after

```bash
bin/jobs start
```

## Fixes with

This will run rubocop and brakeman

```bash
bin/fix_before_push
```
