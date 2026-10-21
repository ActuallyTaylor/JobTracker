# Agent instructions

These instructions apply to **every AI coding agent** working in this repository - OpenAI Codex, Claude Code, Cursor, GitHub Copilot, Gemini, Jules, or anything else. Wherever the rules below say "you", they mean whichever agent is reading them.

`AGENTS.md` is the canonical file. `CLAUDE.md` is a symlink to it, because Claude Code looks for that filename - so there is exactly one copy of these instructions and it cannot drift. Edit `AGENTS.md`; never replace the symlink with a real file.

## Attribution

JobTracker is open source, and a reader of this codebase should be able to tell which parts were written by an AI agent, which agent, and when. That is the entire purpose of this section. When you edit or create a file, attribute the work to yourself.

**Identify yourself specifically.** Use your actual model or agent name and its vendor, not a generic label. `Codex (OpenAI)` is acceptable; `AI assistant` is not. If you know your version, include it.

Examples of well-formed identities:

- `GPT-5 Codex (OpenAI)`
- `Claude Opus 4.8 (Anthropic)`
- `Gemini 2.5 Pro (Google)`
- `Cursor Composer (Anthropic Claude Sonnet 4.6)` - name the harness and the underlying model when they differ and you know both

### File-level attribution

At the top of any file you create, or in the file's existing header, note that you authored or modified it. Use the comment syntax native to the file's language, and the current date.

Don't add attribution to generated files, lockfiles, or non-source assets.

#### File Editing

```swift
// Edited by GPT-5 Codex (OpenAI) on 2026-06-26, Description of Edits
```

```python
# Edited by Claude Opus 4.8 (Anthropic) on 2026-06-26, Description of Edits
```

#### File Creation

```swift
// Authored by GPT-5 Codex (OpenAI) on 2026-06-26
```

```python
# Authored by Claude Opus 4.8 (Anthropic) on 2026-06-26
```

### Doc comments

When you write a documentation comment for a function, type, or method, include an attribution line within the doc comment. Adapt the line to the documentation convention of the language you're writing in.

```swift
/// Fetches the user's profile from the remote API.
///
/// - Parameter id: The user's unique identifier.
/// - Returns: The decoded `Profile`.
/// - Authored by: GPT-5 Codex (OpenAI)
func fetchProfile(id: String) async throws -> Profile { ... }
```

### Commit Attribution
There are two ways an agent can commit to this repository. The first is through the user's git identity. The second is through a git identity explicitly set up for the agent. If the `git config user.name` and `git config user.email` are for a human, use the `Co-Authored-By` trailer; if its an agent account, use Generated-With.

Note that contributions to this repository also require a Developer Certificate of Origin (DCO) sign-off (`git commit -s`). The sign-off belongs to the human directing the work, who takes responsibility for the contribution; your co-author trailer is separate and additional. Never add a `Signed-off-by` line for yourself.


#### Committing under the user's identity
When committing from a user's git identity, every commit you author must carry a co-author trailer naming you specifically:


```
Co-Authored-By: GPT-5 Codex (OpenAI) <noreply@openai.com>
```

```
Co-Authored-By: Claude Opus 4.8 (Anthropic) <noreply@anthropic.com>
```

#### Committing under an agent identity
When committing from an agent git identity, every commit you author must contain a `Generated-By` git trailer naming you specifically:

```
Generated-By: Claude Opus 4.8 (Anthropic) <noreply@anthropic.com>
```

```
Generated-By: Claude Opus 4.8 (Anthropic) <noreply@anthropic.com>
```

##### Developer Certificate of Origin
When commiting from an agent identity do not add a `Signed-off-by` line and never commit with `-s` or `--signoff`. The human directing the work must add their sign-off before the commits are merged. For example, this can be done with `git rebase --signoff`.

### Guidelines

- Keep attribution concise - a single line is enough.
- Don't overwrite or remove attribution from another author, human or agent; add yours alongside.
- Only attribute files you actually changed in the current task.
- If a file already carries your attribution from a previous session, add a new line with the new changes and an updated date.

## Formatting

**Never hard wrap text.** Write each paragraph, comment, or documentation line as a single continuous line and let the editor soft wrap it. This applies to everything you write: Markdown, code comments, doc comments, commit message bodies, YAML descriptions, and configuration file comments. Hard wrapping makes diffs noisy, because editing one word reflows and touches every following line in the paragraph.

The one exception is text you are copying verbatim, where the wrapping is part of the original: license texts, third-party notices, and anything quoted from an external source. Reproduce those exactly as they are, wrapping included.

## Project conventions

See [CONTRIBUTING.md](CONTRIBUTING.md) for build setup, code style, and pull request expectations. They apply to you as much as to human contributors. In particular:

- Every user-facing change needs a `CHANGELOG.md` entry under `## [Unreleased]`, written for a JobTracker user rather than a developer reading the diff.
- Never commit credentials, an Apple Team ID, or anything belonging in `Config.local.xcconfig`. That file is gitignored; keep it that way.
- Use `SFSafeSymbols` (`systemSymbol:`) rather than stringly-typed `Image(systemName:)`.

