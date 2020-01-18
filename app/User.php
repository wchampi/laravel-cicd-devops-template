<?php

namespace App;

use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Notifications\Notifiable;
use Jenssegers\Mongodb\Eloquent\Model as Eloquent;

class User extends Eloquent
{
    use Notifiable;

    protected $primaryKey = '_id';

    protected $guarded =[];

	protected $fillable = [];
}
