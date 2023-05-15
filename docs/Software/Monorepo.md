# Monorepo

## Idea

- Polirepo: Have each unit of code in their own space (git repositor)
- MonoRepo: Having all the code of an organization in a single space

There are a bunch of monorepos build systems out there, you could differentiate in two categories:

1. Easy but only for Javascript/Typescript code. example lerna/NX 
2. Extremly complex, and maybe after fighting with the build system. Like Bazel/Buck

I have to say that there is [Pants](https://www.pantsbuild.org/) that seems easier and works for more languages. The issue is that if your language is not 

One key aspect of monorepos, is that they will try to do just what changed, so for each project inside the repo, you need to have a clear dependency graph.

## Benefits 

- Having everything at a single point makes everything more easy.
- The extremly complex build systems, comes with the idea of reproducible builds. Wich mean to copy the dependencies inside the monorepo as well (what if the dependency is not available in 5 years?)
- Broader refactors afecting the whole organization should be easier.

## Cons
- Your build system is engrained with the whole code, and could stop innovation. What will happen if a new language doesn't have support in your build system?

## Thoughts

### Is this similar to Pull Requests, where organizations copy how we do in the Open Source space, even when the conditions are way different? 

In the Open Source space, we want people to contribute but not to own our code, we want to have control cause there is a lack of trust between parties.

For monorepos, this could be similar, on OpenSource we want high collaborations with as less cohesion as possible, for a lot of factors. But in a enterprise organization
Does way more sense to have everything in a single space.

### Language and toolings are prepared?
Tools are expecting have some configuration normally at the start of the git repository, and now this assumption is broken.

Normally each language has a couple of build toolkits that are the most used (npm, gradle/maven, cargo) etc... but 
this tools that are native to the language itself not share the internals so the monorepo build can use them. Forcing
to deduce and replicate logic of each ones.


## Build Systems

### Buck2 - Facebook
- in rust
- buck2 is in beta, but buck is already deprecated... 🤷
- use the startlark language (I think it's the language that bazel also uses)
- at June 2023 feels quite not ready yet...

to install we can just use 
```
rustup install nightly-2023-03-07
cargo +nightly-2023-03-07 install --git https://github.com/facebook/buck2.git buck2
```

After doing the tutorial, found that... surprise! there is no documentation on what are
the commands you can use in the `BUCK` files... the only "documentation" I found is looking
directly to the [prelude](https://github.com/facebook/buck2/tree/main/prelude) in github. Maybe
they use startlark the names of the functions are the same... but it doesn't seem mature enough
to have a look at it.

### Bazel - Google
### Pants - Twitter and others




## References

- [monorepo.tools](https://monorepo.tools/)
- [Mono repo history](https://earthly.dev/blog/pants-build/)
