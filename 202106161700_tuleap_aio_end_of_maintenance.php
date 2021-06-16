<?php
/**
 * Copyright (c) Enalean, 2021 - Present. All Rights Reserved.
 *
 *  This file is a part of Tuleap.
 *
 *  Tuleap is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  Tuleap is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with Tuleap. If not, see <http://www.gnu.org/licenses/>.
 */

declare(strict_types=1);

// phpcs:ignore PSR1.Classes.ClassDeclaration.MissingNamespace,Squiz.Classes.ValidClassName.NotCamelCaps
final class b202106161700_tuleap_aio_end_of_maintenance extends ForgeUpgrade_Bucket
{
    public function description(): string
    {
        return 'Inform about enalean/tuleap-aio end of life';
    }

    public function preUp(): void
    {
        $this->db = $this->getApi('ForgeUpgrade_Bucket_Db');
    }

    public function up(): void
    {
        $sql = 'INSERT INTO platform_banner(importance, message) VALUES ("critical", "This platform is based on docker image <a href=https://hub.docker.com/r/enalean/tuleap-aio>enalean/tuleap-aio</a> that is no longer maintained. Please report this issue to Tuleap admins and check <a href=https://hub.docker.com/r/tuleap/tuleap-community-edition>new docker image</a>")';

        $res = $this->db->dbh->exec($sql);
        if ($res === false) {
            throw new ForgeUpgrade_Bucket_Exception_UpgradeNotComplete('cannot add message');
        }
    }
}
