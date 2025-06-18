<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Patient extends Model
{
    protected $table='patient';

    protected $primaryKey='patient_id';

    protected $fillable=['p_name','p_blood','p_age','p_location'];
}
