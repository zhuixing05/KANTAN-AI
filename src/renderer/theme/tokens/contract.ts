/**
 * Token Contract — defines all semantic variables a theme must provide.
 *
 * Naming: --kantan-{category}-{name}
 * Convention: shadcn/ui background/foreground pairing + Radix 12-step gray scale
 *
 * Every theme (ThemeDefinition.tokens) must supply a value for each key.
 */
export const TOKEN_CONTRACT = {
  // ── Brand ──
  'primary':            '--kantan-primary',
  'primary-foreground': '--kantan-primary-foreground',
  'primary-hover':      '--kantan-primary-hover',
  'primary-muted':      '--kantan-primary-muted',

  // ── Accent ──
  'accent':             '--kantan-accent',
  'accent-foreground':  '--kantan-accent-foreground',

  // ── Surface / Background ──
  'background':         '--kantan-background',
  'foreground':         '--kantan-foreground',
  'surface':            '--kantan-surface',
  'surface-foreground': '--kantan-surface-foreground',
  'surface-raised':     '--kantan-surface-raised',
  'surface-overlay':    '--kantan-surface-overlay',

  // ── Chat bubbles ──
  'chat-user':              '--kantan-chat-user',
  'chat-user-foreground':   '--kantan-chat-user-foreground',
  'chat-bot':               '--kantan-chat-bot',
  'chat-bot-foreground':    '--kantan-chat-bot-foreground',

  // ── Text hierarchy ──
  'text-primary':       '--kantan-text-primary',
  'text-secondary':     '--kantan-text-secondary',
  'text-muted':         '--kantan-text-muted',

  // ── Borders ──
  'border':             '--kantan-border',
  'border-subtle':      '--kantan-border-subtle',
  'input-border':       '--kantan-input-border',

  // ── Scrollbar ──
  'scroll-thumb':       '--kantan-scroll-thumb',
  'scroll-thumb-hover': '--kantan-scroll-thumb-hover',

  // ── Decorative gradients ──
  'gradient-1':         '--kantan-gradient-1',
  'gradient-2':         '--kantan-gradient-2',

  // ── Status ──
  'destructive':            '--kantan-destructive',
  'destructive-foreground': '--kantan-destructive-foreground',
  'success':                '--kantan-success',
  'warning':                '--kantan-warning',

  // ── Gray scale 11 steps (gray-1=lightest → gray-11=darkest, all themes) ──
  'gray-1':  '--kantan-gray-1',
  'gray-2':  '--kantan-gray-2',
  'gray-3':  '--kantan-gray-3',
  'gray-4':  '--kantan-gray-4',
  'gray-5':  '--kantan-gray-5',
  'gray-6':  '--kantan-gray-6',
  'gray-7':  '--kantan-gray-7',
  'gray-8':  '--kantan-gray-8',
  'gray-9':  '--kantan-gray-9',
  'gray-10': '--kantan-gray-10',
  'gray-11': '--kantan-gray-11',

  // ── Radius ──
  'radius':  '--kantan-radius',
} as const;

export type TokenName = keyof typeof TOKEN_CONTRACT;
export type CSSVarName = (typeof TOKEN_CONTRACT)[TokenName];

/** All token keys as an array */
export const TOKEN_NAMES = Object.keys(TOKEN_CONTRACT) as TokenName[];
