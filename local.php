<?php
/**
 * Local Configuration Override
 *
 * This configuration override file is for overriding environment-specific and
 * security-sensitive configuration information. Copy this file without the
 * .dist extension at the end and populate values as needed.
 *
 * @NOTE: This file is ignored from Git by default with the .gitignore included
 * in ZendSkeletonApplication. This is a good practice, as it prevents sensitive
 * credentials from accidentally being committed into version control.
 */
$package_json = json_decode(file_get_contents('./package.json'), true);

return [
    'doctrine' => [
        'connection' => [
            'orm_default' => [
                'params' => [
                    'host' => getenv('db_host'),
                    'user' => getenv('db_user'),
                    'password' => getenv('db_pass'),
                    'dbname' => getenv('db_common_name'),
                ],
            ],
            'orm_cli' => [
                'params' => [
                    'host' => getenv('db_host'),
                    'user' => getenv('db_user'),
                    'password' => getenv('db_pass'),
                    'dbname' => getenv('db_cli_name'),
                ],
            ],
        ],
    ],

    'languages' => [
        'fr' => [
            'index' => 1,
            'label' => 'Français',
        ],
        'en' => [
            'index' => 2,
            'label' => 'English',
        ],
        'de' => [
            'index' => 3,
            'label' => 'Deutsch',
        ],
        'nl' => [
            'index' => 4,
            'label' => 'Nederlands',
        ],
        'es' => [
            'index' => 5,
            'label' => 'Spanish',
        ],
        'it' => [
            'index' => 6,
            'label' => 'Italian',
        ],
        'ru' => [
            'index' => 7,
            'label' => 'Russian',
        ],
        'pt' => [
            'index' => 8,
            'label' => 'Portuguese',
        ],
        'pl' => [
            'index' => 9,
            'label' => 'Polish',
        ],
        'jp' => [
            'index' => 10,
            'label' => 'Japanese',
        ],
        'zh' => [
            'index' => 11,
            'label' => 'Chinese',
        ],
    ],

    'defaultLanguageIndex' => 1,

    'activeLanguages' => array('fr','en','de','nl','es','it','ja','pl','pt','ru','zh'),

    'appVersion' => $package_json['version'],

    'checkVersion' => true,
    'appCheckingURL' => 'https://version.monarc.lu/check/MONARC',

    'email' => [
        'name' => 'MONARC',
        'from' => 'info@monarc.lu',
    ],

    'terms' => 'https://my.monarc.lu/terms.html',

    'monarc' => [
        'ttl' => 60,
        'cliModel' => 'generic',
    ],

    'mospApiUrl' => 'https://objects.monarc.lu/api/',

    'statsApi' => [
        'baseUrl' => 'http://127.0.0.1:5005',
        'apiKey' => '',
    ],
];
