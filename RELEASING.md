# Releasing Miron

- Make sure all issues and PRs marked in the version's milestone have
  been closed and addressed.
- Update `lib/miron/version.rb` file accordingly.
- Make sure the `CHANGELOG.md` has all of the correct shipped items
  inside of it.
- Commit once you have updated the `version.rb` file --> `Release
  v0.0.3`
- Tag the release: git tag -m 'vVERSION' vVERSION
- Push changes: `git push --tags`
- `cd` into the `pkg/` directory, and then build + publish the gem:

```
gem build miron.gemspec
gem push miron-VERSION.gem
```

Announce the new release, making sure to say “thank you” to the contributors who helped shape this version.
