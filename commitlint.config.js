module.exports = {
	extends: ['@commitlint/config-conventional'],
	rules: {
		'type-enum': [
			2,
			'always',
			[
				'feat',     // New feature
				'fix',      // Bug fix
				'docs',     // Documentation only changes
				'style',    // Code style changes (formatting, etc)
				'refactor', // Code change that neither fixes a bug nor adds a feature
				'perf',     // Performance improvements
				'test',     // Adding missing tests or correcting existing tests
				'build',    // Changes that affect the build system
				'ci',       // Changes to CI configuration files and scripts
				'chore',    // Other changes that don't modify src or test files
				'revert',   // Reverts a previous commit
			],
		],
		'type-case': [2, 'always', 'lower-case'],
		'type-empty': [2, 'never'],
		'scope-case': [2, 'always', 'lower-case'],
		'subject-case': [2, 'always', 'lower-case'],
		'subject-empty': [2, 'never'],
		'subject-full-stop': [2, 'never', '.'],
		'header-max-length': [2, 'always', 100],
		'body-leading-blank': [2, 'always'],
		'body-max-line-length': [2, 'always', 100],
		'footer-leading-blank': [2, 'always'],
		'footer-max-line-length': [2, 'always', 100],
	},
};
